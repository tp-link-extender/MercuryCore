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
} satisfies import("./Assets/schema.ts").Config
