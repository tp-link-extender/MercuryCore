import adapter from "@bun-community/sveltekit-adapter-bun"
import preprocess from "svelte-preprocess"
import autoImport from "sveltekit-autoimport"
import { resolve } from "path"

export default {
	// Consult https://github.com/sveltejs/svelte-preprocess
	// for more information about preprocessors
	preprocess: [
		preprocess({
			stylus: {
				prependData: '@import "src/variables.styl"',
			},
		}),
		autoImport({
			components: ["./src/lib/components"],
			module: {
				svelte: ["onMount"],
				"svelte/store": ["writable"],
				"$app/forms": ["enhance", "deserialize"],
			},
			mapping: {
				fade: 'import fade from "$lib/fade"',
			},
			include: ["**/*.svelte", "**/*.ts"],
		}),
	],

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
					  resolve("src/bootstrap.css"),
		},
	},

	vitePlugin: {
		inspector: {
			toggleKeyCombo: "control-i",
		},
	},
}
