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
					? `${e(rawSelector)}:before{content:"\\${fa[c]}"!important}`
					: "",
		],
	],

	presets: [presetTagify(), presetAttributify(), presetUno()],
	transformers: [transformerDirectives(), transformerVariantGroup()],
})
