import adapter from "@sveltejs/adapter-node"
import preprocess from "./svelte-preprocess/dist/index.js"
import { resolve } from "path"

export default {
	// Consult https://github.com/sveltejs/svelte-preprocess
	// for more information about preprocessors
	preprocess: [preprocess()],

	kit: {
		adapter: adapter(),
		files: {
			lib: "./src/lib",
		},
		alias: {
			$bootstrap:
				process.env.NODE_ENV == "production"
					? resolve("src/bootstrap.sass")
					: // Using the css version in development, because
					  // the sass compiler slows the dev server to a crawl
					  resolve("node_modules/bootstrap/dist/css/bootstrap.css"),
		},

		moduleExtensions: [".js", ".ts", ".civet"],
	},

	vitePlugin: {
		inspector: {
			toggleKeyCombo: "control-i",
		},
	},
}
