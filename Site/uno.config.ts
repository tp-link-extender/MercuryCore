import presetTagify from "@unocss/preset-tagify"
import transformerDirectives from "@unocss/transformer-directives"
import transformerVariantGroup from "@unocss/transformer-variant-group"
import { defineConfig, toEscapedSelector as e, presetAttributify } from "unocss"
import presetWind3 from "unocss/preset-wind3"
import fa from "./src/icons.json"

export default defineConfig({
	presets: [presetTagify(), presetAttributify(), presetWind3()],
	rules: [
		[
			/^fa-([a-zA-Z0-9-]+)$/,
			([, c], { rawSelector }) =>
				fa[c]
					? `${e(rawSelector)}:before{content:"\\${fa[c]}"!important}`
					: "",
		],
	],
	transformers: [transformerDirectives(), transformerVariantGroup()],
})
