import adapter from "@sveltejs/adapter-node"
import { vitePreprocess } from "@sveltejs/vite-plugin-svelte"

/** @type {import("@sveltejs/kit").Config} */
export default {
	// Consult https://github.com/sveltejs/svelte-preprocess for more information about preprocessors
	preprocess: vitePreprocess(),
	kit: {
		adapter: adapter(),
		alias: { $components: "./src/components" },
	},
	vitePlugin: { inspector: { toggleKeyCombo: "control-i" } },
}
