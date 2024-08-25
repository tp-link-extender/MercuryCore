// Configuration file for Mercury Core. Hover over a property to see its description!
// If you're running in production, you'll need to rebuild Mercury Core to apply changes.

export default {
	Name: "Mercury",
	Domain: "mercury2.com",
	DatabaseURL: "http://localhost:8000",
	RCCServiceProxyURL: "http://localhost:64990",
	CurrencySymbol: "屌",

	// 'noob' colours
	DefaultBodyColors: {
		Head: 24,
		LeftArm: 24,
		LeftLeg: 119,
		RightArm: 24,
		RightLeg: 119,
		Torso: 23,
	},

	Logging: {
		Requests: true,
		FormattedErrors: false,
		Time: true,
	},

	Branding: {
		Favicon: "favicon.svg",
		Icon: "icon.svg",
		Tagline: "Revival tagline",
		Descriptions: {
			"Endless possibilites":
				"Create or play your favourite games and customise your character with items on our catalog.",
			"New features":
				"In addition to full client usability, additional features such as security fixes, QoL fixes and an easy to use website make your experience better.",
			"Same nostalgia":
				"All of our clients will remain as vanilla as possible, to make sure it's exactly as you remember it.",
		},
	},

	Themes: [
		{
			Name: "Standard",
			Path: "standard.css",
		},
	],
} satisfies import("./Assets/schema.ts").Config
