import { resolve } from "node:path"
import { preprocessMeltUI, sequence } from "@melt-ui/pp"
import adapter from "@sveltejs/adapter-node"
import preprocess from "svelte-preprocess"

/** @type {import("@sveltejs/kit").Config}*/
export default {
	// Consult https://github.com/sveltejs/svelte-preprocess for more information about preprocessors
	preprocess: sequence([
		preprocess({ stylus: { prependData: '@import "src/variables.styl"' } }),
		preprocessMeltUI(),
	]),
	kit: {
		adapter: adapter(),
		files: { lib: "./src/lib" },
	},

	vitePlugin: { inspector: { toggleKeyCombo: "control-i" } },
}
