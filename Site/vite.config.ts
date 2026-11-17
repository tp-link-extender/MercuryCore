import adapter from "@sveltejs/adapter-bun"
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
			// precompress writes .br and .gz variants of client and prerendered assets, which are negotiated per request
			adapter: adapter({ precompress: true }),

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
			inspector: { toggleKeyCombo: "control-i" },

			// Consult https://github.com/sveltejs/svelte-preprocess for more information about preprocessors
			preprocess: vitePreprocess(),
		}),
		devtoolsJson(),
	],
	ssr: { noExternal: ["d3-interpolate"] },
})
