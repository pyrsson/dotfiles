/**
 * Calculates a match score between two strings based on ordered matching characters
 * and their proximity. A higher score indicates a better match.
 *
 * The scoring is based on:
 * - The number of matching characters in the same order.
 * - A bonus for consecutive matching characters.
 * - A bonus for how close the matching characters are to each other.
 *
 * @param query The string to search for.
 * @param item The string to search within.
 * @returns A number representing the match score.
 */
export const calculateMatchScore = (query: string, item: string): number => {
  let score = 0;
  let lastMatchIndex = -1;
  let consecutiveMatchBonus = 0;
  const lowerCaseQuery = query.toLowerCase();
  const lowerCaseItem = item.toLowerCase();

  // Bonus for matching the start of the string
  if (lowerCaseItem.startsWith(lowerCaseQuery)) {
    score += lowerCaseQuery.length * 2; // Strong bonus for prefix match
  }

  for (let i = 0; i < lowerCaseQuery.length; i++) {
    const queryChar = lowerCaseQuery[i];
    // Find the next occurrence of the character in `item` after the last match
    const matchIndex = lowerCaseItem.indexOf(queryChar, lastMatchIndex + 1);

    if (matchIndex !== -1) {
      // Base score for finding a character in order
      score += 1;

      if (lastMatchIndex !== -1) {
        const distance = matchIndex - lastMatchIndex;
        // Proximity bonus: higher for closer matches
        if (distance > 0) {
          score += 1 / distance;
        }
      }

      // Consecutiveness bonus
      if (matchIndex === lastMatchIndex + 1) {
        consecutiveMatchBonus += 1;
        score += consecutiveMatchBonus * 2;
      } else {
        consecutiveMatchBonus = 0;
      }

      lastMatchIndex = matchIndex;
    }
  }

  return score;
};

/**
 * Represents a single fuzzy match result.
 */
export interface FuzzyMatchResult {
  result: any;
  /**
   * A custom score indicating the quality of the match. A higher score is better.
   * This score considers recency, matching characters in order, and proximity of matches.
   */
  score: number;
}
