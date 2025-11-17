// Configuration file for Mercury Core. Hover over a property to see its description!
// If you're running in production, you'll need to rebuild Mercury Core to apply changes.

export default {
	Name: "Mercury",
	Domain: "mercs.dev",
	DatabaseURL: "http://localhost:8000",
	RCCServiceProxyURL: "http://localhost:64990",
	OrbiterPrivateURL: "http://localhost:64991",
	OrbiterPublicURL: "http://localhost:64992",
	LauncherURI: "mercury-launcher:",
	CurrencySymbol: "屌",
	Pages: ["Statistics", "Forum", "Groups"],

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
		Favicon: "Branding/Favicon.svg",
		Icon: "Branding/Icon.svg",
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

	Images: {
		DefaultPlaceIcons: ["Images/DefaultIcon1.avif"],
		DefaultPlaceThumbnails: [
			"Images/DefaultThumbnail1.avif",
			"Images/DefaultThumbnail2.avif",
			"Images/DefaultThumbnail3.avif",
		],
	},

	Themes: [
		{
			Name: "Standard",
			Path: "Themes/Standard.css",
		},
	],

	Filtering: {
		FilteredWords: [],
		ReplaceWith: "#",
		ReplaceType: "Character",
	},

	Registration: {
		Keys: {
			Enabled: true,
			Prefix: "mercurkey-",
		},
		Emails: true,
	},

	Email: {
		Host: "smtp.example.com",
		Port: 587,
		Username: "username",
	},

	Gameservers: {
		Hosting: "Both",
	},
} satisfies import("./Assets/schema.ts").Config
