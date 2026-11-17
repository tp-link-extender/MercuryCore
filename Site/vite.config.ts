import adapter from "@sveltejs/adapter-node"
import { sveltekit } from "@sveltejs/kit/vite"
import { vitePreprocess } from "@sveltejs/vite-plugin-svelte"
import extractorSvelte from "@unocss/extractor-svelte"
import UnoCSS from "unocss/vite"
import { defineConfig } from "vite"
import devtoolsJson from "vite-plugin-devtools-json"

export default defineConfig({
	plugins: [
		{
			name: "surql",
			transform(src: string, id: string) {
				if (id.endsWith(".surql")) return `export default \`${src}\``
			},
		},
		UnoCSS({ extractors: [extractorSvelte] }),
		sveltekit({
			adapter: adapter(),

			// shorter hashes (normal hashes are svelte-{hash}). This doesn't work in development so expect a warning from vite-plugin-svelte, though works fine in production builds.
			compilerOptions: {
				cssHash: ({ hash, filename }) => `s${hash(filename)}`,

				experimental: {
					async: true,
				},
				modernAst: true,
				// These become defaults in Svelte 6
				runes: true,
			},

			experimental: {
				remoteFunctions: true,
			},

			// Consult https://github.com/sveltejs/svelte-preprocess for more information about preprocessors
			preprocess: vitePreprocess(),
			inspector: { toggleKeyCombo: "control-i" },
		}),
		devtoolsJson(),
	],
	ssr: { noExternal: ["d3-interpolate"] },
})
