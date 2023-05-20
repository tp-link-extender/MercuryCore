import { sveltekit } from "@sveltejs/kit/vite"
import { warmup } from "vite-plugin-warmup"
import UnoCSS from "unocss/vite"
import civet from "vite-plugin-civet"
import extractorSvelte from "@unocss/extractor-svelte"
import { defineConfig } from "vite"

export default defineConfig({
	plugins: [
		warmup({
			clientFiles: ["./src/**/*.svelte"],
		}),
		UnoCSS({
			extractors: [extractorSvelte],
		}),
		sveltekit(),
		civet({
			outputExtension: ".ts",
			include: "**/*.js",
		}),
	],

	ssr: {
		noExternal: ["three", "troika-three-text", "d3-interpolate"],
	},
})
