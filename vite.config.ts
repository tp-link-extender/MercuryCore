import { sveltekit } from "@sveltejs/kit/vite"
import mkcert from "vite-plugin-mkcert"

export default {
	plugins: [sveltekit(), mkcert()],

	server: {
		watch: {
			usePolling: true,
		},
	},
	ssr: {
		noExternal: ["three", "troika-three-text", "@lucia-auth/sveltekit"],
	},
}
