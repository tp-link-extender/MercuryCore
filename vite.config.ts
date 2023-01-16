import { sveltekit } from "@sveltejs/kit/vite"
import mkcert from "vite-plugin-mkcert"

export default {
	plugins: [sveltekit(), mkcert()],

	ssr: {
		noExternal: ["three", "troika-three-text", "@lucia-auth/sveltekit"],
	},
}
