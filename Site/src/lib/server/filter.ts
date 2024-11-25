import config from "$lib/server/config"
import type {
	PreTrainedTokenizer,
	TextClassificationPipeline,
} from "@huggingface/transformers"

const { FilteredWords, ReplaceType, ReplaceWith } = config.Filtering
const replaceChar = ReplaceType === "Character"
const replace = (word: string) =>
	replaceChar ? ReplaceWith.repeat(word.length) : config.Filtering.ReplaceWith

let classifier: TextClassificationPipeline
let tokeniser: PreTrainedTokenizer

// model: https://huggingface.co/badmatr11x/distilroberta-base-offensive-hateful-speech-text-multiclassification
// model labels: https://huggingface.co/badmatr11x/distilroberta-base-offensive-hateful-speech-text-multiclassification/blob/main/config.json
const model =
	"badmatr11x/distilroberta-base-offensive-hateful-speech-text-multiclassification"

async function MLReplace(text: string) {
	const { pipeline, AutoTokenizer } = await import(
		"@huggingface/transformers"
	)
	await Promise.all([
		!classifier &&
			(async () => {
				classifier = await pipeline("text-classification", model)
			}),
		!tokeniser &&
			(async () => {
				tokeniser = await AutoTokenizer.from_pretrained(model)
			}),
	])

	const result = await classifier(text)
	console.log(result)
	return ""
}

/**
 * Filter a string of text for profanity, replacing words with #s depending on on text filtering configuration options.
 * @param text The text to filter.
 * @returns The filtered text.
 * @example
 * filter("FUCK!!!")
 */
export default (text: string) => {
	// Replace all words in the text with #s proportional to the length of the word
	if (ReplaceType === "ML") return MLReplace(text)
	return text.replaceAll(/\b(\w+)\b/g, (_, word) =>
		FilteredWords.indexOf(word.toLowerCase()) !== -1 ? replace(word) : word
	)
}
