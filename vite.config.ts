import { sveltekit } from "@sveltejs/kit/vite"
import { defineConfig } from "vite"
import { warmup } from "vite-plugin-warmup"
import UnoCSS from "unocss/vite"
import extractorSvelte from "@unocss/extractor-svelte"
import inlangPlugin from "@inlang/sdk-js/adapter-sveltekit"

export default defineConfig({
	plugins: [
		warmup({
			clientFiles: ["./src/**/*.svelte"],
		}),
		UnoCSS({
			extractors: [extractorSvelte],
		}),
		inlangPlugin(),
		sveltekit(),
	],

	ssr: {
		noExternal: ["three", "troika-three-text", "d3-interpolate"],
	},
})
