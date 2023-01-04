import { sveltekit } from "@sveltejs/kit/vite"
import mkcert from "vite-plugin-mkcert"
import path from "path"

export default {
	plugins: [sveltekit(), mkcert()],

	resolve: {
		alias: {
			"~bootstrap": path.resolve(__dirname, "node_modules/bootstrap"),
		},
	},
	ssr: {
		noExternal: ["three", "troika-three-text", "@lucia-auth/sveltekit"],
	},
}
