import adapter from "@sveltejs/adapter-node"
import { vitePreprocess } from "@sveltejs/vite-plugin-svelte"

/** @type {import("@sveltejs/kit").Config} */
export default {
	compilerOptions: {
		// shorter hashes (normal hashes are svelte-{hash}). This doesn't work in development so expect a warning from vite-plugin-svelte, though works fine in production builds.
		cssHash: ({ hash, filename }) => `s${hash(filename)}`,

		experimental: {
			async: true,
		},
		modernAst: true,
		// These become defaults in Svelte 6
		runes: true,
	},
	kit: {
		adapter: adapter(),
		alias: { $components: "./src/components" },

		experimental: {
			remoteFunctions: true,
		},
	},
	// Consult https://github.com/sveltejs/svelte-preprocess for more information about preprocessors
	preprocess: vitePreprocess(),
	vitePlugin: { inspector: { toggleKeyCombo: "control-i" } },
}
