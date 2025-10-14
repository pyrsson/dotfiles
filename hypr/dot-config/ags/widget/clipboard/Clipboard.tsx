import { For, createState } from "ags";
import { Astal, Gtk, Gdk } from "ags/gtk4";
import Graphene from "gi://Graphene";
import { requests, setVisibleWindow, visibleWindow } from "../../app";
import Clipboard, { Entry } from "./cliphist";
import Adw from "gi://Adw?version=1";
import Pango from "gi://Pango?version=1.0";

const { TOP, BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor;

export default function Cliphist() {
  let contentbox: Gtk.Box;
  let searchentry: Gtk.Entry;
  let win: Astal.Window;
  let listbox: Gtk.ListBox;

  const cliphist = Clipboard.get_default();
  const [list, setList] = createState(new Array<Entry>());

  requests.get().set("cliphist", (res) => {
    const win = visibleWindow.get();

    if (win === "cliphist") setVisibleWindow("");
    else setVisibleWindow("cliphist");
    res("ok");
  });

  function search(text: string) {
    if (text === "") setList(cliphist.list.slice(0, 8));
    else setList(cliphist.fuzzy_query(text).slice(0, 8));
  }

  function select(entry?: Entry) {
    if (entry) {
      setVisibleWindow("");
      entry.copy();
    }
  }

  // close on ESC
  // handle alt + number key
  function onKey(
    _e: Gtk.EventControllerKey,
    keyval: number,
    _: number,
    mod: number,
  ) {
    if (keyval === Gdk.KEY_Escape) {
      setVisibleWindow("");
      return;
    }

    if (mod === Gdk.ModifierType.ALT_MASK) {
      for (const i of [1, 2, 3, 4, 5, 6, 7, 8, 9] as const) {
        if (keyval === Gdk[`KEY_${i}`]) {
          return select(list.get()[i - 1]);
        }
      }
    }
  }

  // close on clickaway
  function onClick(_e: Gtk.GestureClick, _: number, x: number, y: number) {
    const [, rect] = contentbox.compute_bounds(win);
    const position = new Graphene.Point({ x, y });

    if (!rect.contains_point(position)) {
      setVisibleWindow("");
      return true;
    }
  }

  return (
    <window
      $={(ref) => (win = ref)}
      name="cliphist"
      class="Picker"
      namespace={"ags-cliphist"}
      anchor={TOP}
      exclusivity={Astal.Exclusivity.NORMAL}
      keymode={Astal.Keymode.EXCLUSIVE}
      visible={visibleWindow.as((win) => win === "cliphist")}
      onNotifyVisible={({ visible }) => {
        if (visible)
          searchentry.grab_focus() && setList(cliphist.list.slice(0, 8));
        else searchentry.set_text("");
      }}
      marginTop={8}
    >
      <Adw.Clamp maximumSize={400}>
        <Gtk.EventControllerKey onKeyPressed={onKey} />
        <Gtk.GestureClick onPressed={onClick} />
        <box
          $={(ref) => (contentbox = ref)}
          name="picker-content"
          valign={Gtk.Align.START}
          halign={Gtk.Align.CENTER}
          orientation={Gtk.Orientation.VERTICAL}
          widthRequest={400}
        >
          <entry
            $={(ref) => (searchentry = ref)}
            onNotifyText={({ text }) => search(text)}
            onActivate={() => select(list.get()[0])}
            placeholderText="Start typing to search"
          />
          <Gtk.Separator visible={list((l) => l.length > 0)} />
          <box orientation={Gtk.Orientation.VERTICAL}>
            <For each={list}>
              {(cliphist, index) => (
                <button onClicked={() => select(cliphist)}>
                  <box>
                    <label
                      label={cliphist.text}
                      wrap
                      wrapMode={Pango.WrapMode.WORD_CHAR}
                    />
                    <label
                      hexpand
                      halign={Gtk.Align.END}
                      label={index((i) => `alt+${i + 1}`)}
                    />
                  </box>
                </button>
              )}
            </For>
          </box>
          <Gtk.ListBox
            $={(ref) => (listbox = ref)}
            selectionMode={Gtk.SelectionMode.NONE}
            widthRequest={400}
          />
        </box>
      </Adw.Clamp>
    </window>
  );
}
