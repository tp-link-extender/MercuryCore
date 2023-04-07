import { sveltekit } from "@sveltejs/kit/vite"
import { warmup } from "vite-plugin-warmup"
import UnoCSS from "unocss/vite"
import { extractorSvelte } from "@unocss/core"
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
	],

	ssr: {
		noExternal: ["three", "troika-three-text"],
	},
})
