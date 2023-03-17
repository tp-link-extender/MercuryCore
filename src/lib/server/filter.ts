import words from "profane-words"

export default (text: string) =>
	// Replace all words in the text with #s proportional to the length of the word
	text.replaceAll(/\b(\w+)\b/g, (_, word) =>
		words.indexOf(word.toLowerCase()) != -1 ? "#".repeat(word.length) : word
	)
