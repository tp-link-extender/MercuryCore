import adapter from "@sveltejs/adapter-auto"
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
