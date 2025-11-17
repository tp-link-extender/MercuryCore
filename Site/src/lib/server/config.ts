import { type } from "arktype"
import { brickColoursStrings } from "$lib/brickColours"
import rawconfig from "../../../../mercury.core"

if (!process.versions.bun || !Bun) {
	const runtime = process.versions.node ? "Node" : "an incorrect runtime"
	console.error(
		`Bun not detected. Did you accidentally start Mercury Core with ${runtime}?`
	)
	process.exit(1)
}

const cwd = process.cwd()
if (!cwd.endsWith("Site")) {
	console.error(
		`Current working directory should be the Site folder, but is ${cwd}`
	)
	process.exit(1)
}

const brickColourEnum = type.or(...brickColoursStrings)

const optionalPages = ["Statistics", "Groups", "Forum"] as const
export type OptionalPage = (typeof optionalPages)[number]

const schema = type({
	Name: "string >= 1",
	Domain: "string >= 1",
	DatabaseURL: "string >= 1",
	RCCServiceProxyURL: "string >= 1",
	OrbiterPrivateURL: "string >= 1",
	OrbiterPublicURL: "string >= 1",
	LauncherURI: "string >= 1",
	CurrencySymbol: "string >= 1",
	Pages: type.enumerated(...optionalPages).array(),

	DefaultBodyColors: type({
		Head: brickColourEnum,
		LeftArm: brickColourEnum,
		LeftLeg: brickColourEnum,
		RightArm: brickColourEnum,
		RightLeg: brickColourEnum,
		Torso: brickColourEnum,
	}),

	Logging: type({
		Requests: "boolean",
		FormattedErrors: "boolean",
		Time: "boolean",
	}),

	Images: type({
		DefaultPlaceIcons: "(string >= 1)[]",
		DefaultPlaceThumbnails: "(string >= 1)[]",
	}),

	Branding: type({
		Favicon: "string >= 1",
		Icon: "string >= 1",
		Tagline: "string",
	}),

	Themes: type({
		Name: "string >= 1",
		Path: "string >= 1",
	})
		.array()
		.atLeastLength(1),

	Filtering: type({
		FilteredWords: "(string >= 1)[]",
		ReplaceWith: "string",
		ReplaceType: type.enumerated("Character", "Word"),
	}),

	Registration: type({
		Keys: type({
			Enabled: "boolean",
			Prefix: "string",
		}),
		Emails: "boolean",
	}),

	Email: type({
		Host: "string >= 1",
		Port: "1 <= number <= 65535",
		Username: "string >= 1",
	}),

	Gameservers: type({
		Hosting: type.enumerated("Selfhosted", "Dedicated", "Both"),
	}),
})

const parseResult = schema(rawconfig)
if (parseResult instanceof type.errors) {
	console.error("Configuration error in mercury.core.ts:")
	for (const error of parseResult)
		console.error(`    ${error.path.join(".")}: ${error.message}`)
	process.exit(1)
}

console.log("Successfully loaded configuration file")

const config = rawconfig // lmfao
export default config
