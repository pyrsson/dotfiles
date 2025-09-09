import GObject, { register, getter } from "ags/gobject";
import { Gdk } from "ags/gtk4";
import { exec } from "ags/process";
import { calculateMatchScore } from "./fuzzy_match";

export class Entry {
  #id: string;
  #text: string;

  constructor(public entry: string) {
    this.entry = entry;
    [this.#id, this.#text] = this.entry.split("\t");
  }

  // #score = 0;

  decode() {
    return exec(`cliphist decode ${this.#id}`);
  }

  copy() {
    const e = exec(`cliphist decode ${this.#id}`);
    Gdk.Display.get_default()?.get_clipboard().set(e);
  }

  get text() {
    return this.#text;
  }

  // get score() {
  //   return this.#score;
  // }
  //
  // set score(score: number) {
  //   this.#score = score;
  // }
}

@register({ GTypeName: "Clipboard" })
export default class Clipboard extends GObject.Object {
  static instance: Clipboard;
  static get_default() {
    if (!this.instance) this.instance = new Clipboard();

    return this.instance;
  }

  #list = exec("cliphist list")
    .split("\n")
    .map((e) => new Entry(e));

  @getter(Array<Entry>)
  get list() {
    return this.#list;
  }

  fuzzy_query(text: string) {
    const results: FuzzyMatchResult[] = [];
    this.list.forEach((entry, index) => {
      const matchScore = calculateMatchScore(text.toLowerCase(), entry.text);

      if (matchScore > 0) {
        // Apply recency factor
        // The boost is proportional to the item's position in the array
        const recencyBoost = 1 + (index / (this.list.length - 1)) * 0.1;
        const finalScore = matchScore * recencyBoost;

        results.push({ entry, score: finalScore });
      }
    });

    // Sort results by score in ascending order (best matches first)
    results.sort((a, b) => b.score - a.score);

    return results.map((r) => r.entry);
  }

  constructor() {
    super();
  }
}

/**
 * Represents a single fuzzy match result.
 */
export interface FuzzyMatchResult {
  entry: Entry;
  /**
   * A custom score indicating the quality of the match. A higher score is better.
   * This score considers recency, matching characters in order, and proximity of matches.
   */
  score: number;
}
