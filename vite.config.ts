import { sveltekit } from "@sveltejs/kit/vite"

export default {
	plugins: [sveltekit()],

	ssr: {
		noExternal: ["three", "troika-three-text", "@lucia-auth/sveltekit"],
	},
}
