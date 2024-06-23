import presetTagify from "@unocss/preset-tagify"
import transformerDirectives from "@unocss/transformer-directives"
import transformerVariantGroup from "@unocss/transformer-variant-group"
import {
	defineConfig,
	toEscapedSelector as e,
	presetAttributify,
	presetUno,
} from "unocss"
import fa from "./src/fa.json"

export default defineConfig({
	rules: [
		[
			/^fa-([a-zA-Z0-9-]+)$/,
			([, c], { rawSelector }) =>
				fa[c]
					? `${e(rawSelector)}:before{content: "\\${
							fa[c]
						}" !important}`
					: "",
		],
		[
			/^fa(r?)$/,
			([, a]) => ({
				"font-family": '"Font Awesome 6"',
				"font-weight": a[0] === "r" ? 400 : 900,
				"-moz-osx-font-smoothing": "grayscale",
				"-webkit-font-smoothing": "antialiased",
				display: "inline-block",
				"font-style": "normal",
				"font-variant": "normal",
				"line-height": "1",
				"text-rendering": "auto",
			}),
		],
	],

	presets: [presetTagify(), presetAttributify(), presetUno()],
	transformers: [transformerDirectives(), transformerVariantGroup()],
})
