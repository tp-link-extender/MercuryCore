import { resolve } from "node:path"
import { preprocessMeltUI, sequence } from "@melt-ui/pp"
import adapter from "@sveltejs/adapter-node"
import preprocess from "svelte-preprocess"

/** @type {import("@sveltejs/kit").Config}*/
export default {
	// Consult https://github.com/sveltejs/svelte-preprocess for more information about preprocessors
	preprocess: sequence([preprocess(), preprocessMeltUI()]),
	kit: {
		adapter: adapter(),
	},

	vitePlugin: { inspector: { toggleKeyCombo: "control-i" } },
}
