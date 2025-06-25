// @ts-check

import starlight from "@astrojs/starlight"
import { defineConfig } from "astro/config"

// https://astro.build/config
export default defineConfig({
	integrations: [
		starlight({
			title: "Mercury Core",
			social: [
				{
					icon: "github",
					label: "GitHub",
					href: "https://github.com/tp-link-extender/MercuryCore",
				},
			],
			sidebar: [
				{
					label: "Guides",
					items: [{ label: "Installation", slug: "guides/install" }],
				},
			],
			components: {
				Head: "./src/components/Head.astro",
			},
			customCss: ["./src/global.css", "./src/fonts/font-face.css"],
		}),
	],
})
