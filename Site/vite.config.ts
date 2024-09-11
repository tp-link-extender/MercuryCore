import { paraglide } from "@inlang/paraglide-sveltekit/vite"
import { sveltekit } from "@sveltejs/kit/vite"
import extractorSvelte from "@unocss/extractor-svelte"
import UnoCSS from "unocss/vite"
import { defineConfig } from "vite"

export default defineConfig({
	plugins: [
		paraglide({
			project: "./project.inlang",
			outdir: "./src/lib/paraglide",
		}),
		{
			name: "surql",
			transform(src: string, id: string) {
				if (id.endsWith(".surql")) return `export default \`${src}\``
			},
		},
		UnoCSS({ extractors: [extractorSvelte] }),
		sveltekit(),
	],
	ssr: { noExternal: ["d3-interpolate"] },
})
