import { sveltekit } from "@sveltejs/kit/vite"
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
		sveltekit(),
		devtoolsJson(),
	],
	server: {
    	allowedHosts: ["mercury.test"]
  	},
	ssr: { noExternal: ["d3-interpolate"] },
})
