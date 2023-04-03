import { sveltekit } from "@sveltejs/kit/vite"
import { warmup } from "vite-plugin-warmup"

export default {
	plugins: [
		warmup({
			clientFiles: ["./src/**/*.svelte"],
		}),
		sveltekit(),
	],

	ssr: {
		noExternal: ["three", "troika-three-text"],
	},
}
