import adapter from "@bun-community/sveltekit-adapter-bun"
import preprocess from "svelte-preprocess"

export default {
	// Consult https://github.com/sveltejs/svelte-preprocess
	// for more information about preprocessors
	preprocess: [preprocess()],

	kit: {
		adapter: adapter(),
		files: {
			lib: "./src/lib",
		},
	},
}
