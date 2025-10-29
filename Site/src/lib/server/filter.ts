import config from "$lib/server/config"

const { FilteredWords, ReplaceType, ReplaceWith } = config.Filtering
const replaceChar = ReplaceType === "Character"
const replace = (word: string) =>
	replaceChar ? ReplaceWith.repeat(word.length) : config.Filtering.ReplaceWith

// Pre-compute a Set for O(1) lookup instead of O(n) indexOf
const filteredWordsSet = new Set(
	(FilteredWords as string[]).map(w => w.toLowerCase())
)

/**
 * Filter a string of text for profanity, replacing words with #s depending on on text filtering configuration options.
 * @param text The text to filter.
 * @returns The filtered text.
 * @example
 * filter("FUCK!!!")
 */
export default (text: string) =>
	// Replace all words in the text with #s proportional to the length of the word
	text.replaceAll(/\b(\w+)\b/g, (_, word) =>
		filteredWordsSet.has(word.toLowerCase()) ? replace(word) : word
	)
