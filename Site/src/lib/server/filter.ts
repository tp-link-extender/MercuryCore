import config from "$lib/server/config"

const { FilteredWords, ReplaceType, ReplaceWith } = config.Filtering
const replaceChar = ReplaceType === "Character"
const replace = (word: string) =>
	replaceChar ? ReplaceWith.repeat(word.length) : config.Filtering.ReplaceWith

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
		FilteredWords.indexOf(word.toLowerCase()) !== -1 ? replace(word) : word
	)

export { default as words } from "profane-words"
