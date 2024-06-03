import { resolve } from "node:path"
import { preprocessMeltUI, sequence } from "@melt-ui/pp"
import adapter from "@sveltejs/adapter-node"
import preprocess from "svelte-preprocess"
import autoImport from "sveltekit-autoimport"

/** @type {import("@sveltejs/kit").Config}*/
export default {
	// Consult https://github.com/sveltejs/svelte-preprocess for more information about preprocessors
	preprocess: sequence([
		preprocess({ stylus: { prependData: '@import "src/variables.styl"' } }),
		autoImport({
			components: [
				"./src/lib/components",
				"./src/lib/components/forms",
				{ name: "./src/lib/components/studio", prefix: "studio" },
			],
			module: {
				svelte: ["onMount", "onDestroy"],
				"svelte/store": ["writable"],
				"$app/forms": ["enhance", "deserialize"],
			},
			mapping: { fade: 'import fade from "$lib/fade"' },
			include: ["**/*.svelte", "**/*.ts"],
		}),
		preprocessMeltUI(),
	]),
	kit: {
		adapter: adapter(),
		files: { lib: "./src/lib" },
	},

	vitePlugin: { inspector: { toggleKeyCombo: "control-i" } },
}
