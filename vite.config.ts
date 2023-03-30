import { sveltekit } from "@sveltejs/kit/vite"
import preprocess from "svelte-preprocess"
import autoimport from "./autoimport"

export default {
	plugins: [
		preprocess(),
		autoimport({
			components: ["./src/lib/components"],
		}),
		sveltekit(),
	],

	ssr: {
		noExternal: ["three", "troika-three-text", "@lucia-auth/sveltekit"],
	},
}
