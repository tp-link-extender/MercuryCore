// @ts-check

import markdoc from "@astrojs/markdoc"
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
					label: "Technology stack",
					slug: "stack",
				},
				{
					label: "Guides",
					autogenerate: { directory: "guides" },
				},
			],
			components: {
				Head: "./src/components/Head.astro",
			},
			customCss: ["./src/global.css", "./src/fonts/font-face.css"],
		}),
		markdoc(),
	],
})
