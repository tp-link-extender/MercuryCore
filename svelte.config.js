import adapter from "@sveltejs/adapter-node"
import preprocess from "./svelte-preprocess/dist/index.js"

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

	vitePlugin: {
		inspector: {
			toggleKeyCombo: "control-i",
		},
	},
}
