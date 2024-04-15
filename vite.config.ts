import { sveltekit } from "@sveltejs/kit/vite"
import { warmup } from "vite-plugin-warmup"
import UnoCSS from "unocss/vite"
import extractorSvelte from "@unocss/extractor-svelte"
import { defineConfig } from "vite"

export default defineConfig({
	plugins: [
		{
			name: "surql",
			transform(src: string, id: string) {
				if (id.endsWith(".surql")) return `export default \`${src}\``
			},
		},
		warmup({
			clientFiles: ["./src/**/*.svelte"],
		}),
		UnoCSS({
			extractors: [extractorSvelte],
		}),
		sveltekit(),
	],

	ssr: {
		noExternal: ["three", "troika-three-text", "d3-interpolate"],
	},
})
