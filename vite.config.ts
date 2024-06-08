import { sveltekit } from "@sveltejs/kit/vite"
import extractorSvelte from "@unocss/extractor-svelte"
import UnoCSS from "unocss/vite"
import { defineConfig } from "vite"

export default defineConfig({
	plugins: [
		{
			name: "surql",
			transform(src: string, id: string) {
				if (id.endsWith(".surql")) return `export default \`${src}\``
			},
		},
		UnoCSS({ extractors: [extractorSvelte] }),
		sveltekit(),
	],
	ssr: { noExternal: ["three", "troika-three-text", "d3-interpolate"] },
	server: { watch: { usePolling: true } },
})
