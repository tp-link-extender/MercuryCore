// @ts-check

import markdoc from "@astrojs/markdoc"
import starlight from "@astrojs/starlight"
import { defineConfig } from "astro/config"

// https://astro.build/config
export default defineConfig({
	integrations: [
		starlight({
			title: "Mercury Core",
			logo: { src: "./public/favicon.svg" },
			social: [
				{
					icon: "github",
					label: "GitHub",
					href: "https://github.com/tp-link-extender/MercuryCore",
				},
			],
			sidebar: [
				{
					label: "Install",
					autogenerate: { directory: "install" },
				},
				{
					label: "Architecture",
					slug: "architecture",
				},
				{
					label: "Services",
					autogenerate: { directory: "services" },
				},
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
