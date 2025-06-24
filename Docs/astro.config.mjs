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
					items: [
						// Each item here is one entry in the navigation menu.
						{ label: "Example guide", slug: "guides/example" },
					],
				},
				{
					label: "Reference",
					autogenerate: { directory: "reference" },
				},
			],
			components: {
				Head: "./src/components/Head.astro",
			},
		}),
	],
})
