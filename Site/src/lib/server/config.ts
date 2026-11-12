import { type } from "arktype"
import { brickColoursStrings } from "$lib/brickColours"
import type { Config } from "../../../../Assets/schema"
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

const optionalPages = Object.freeze(["Statistics", "Groups", "Forum"] as const)
export type OptionalPage = (typeof optionalPages)[number]

const schema = type({
	Branding: type({
		Favicon: "string >= 1",
		Icon: "string >= 1",
		LongTagline: "string",
		Tagline: "string",
	}),
	CurrencySymbol: "string >= 1",

	Database: type({
		AutoStart: "boolean",
		Domain: "string >= 1",
	}),

	DefaultBodyColors: type({
		Head: brickColourEnum,
		LeftArm: brickColourEnum,
		LeftLeg: brickColourEnum,
		RightArm: brickColourEnum,
		RightLeg: brickColourEnum,
		Torso: brickColourEnum,
	}),
	Domain: "string >= 1",
	DomainInsecure: "string >= 1",

	Economy: type({
		AutoStart: "boolean",
	}),

	Email: type({
		Host: "string >= 1",
		Port: "1 <= number <= 65535",
		Secure: "boolean",
		Username: "string >= 1",
	}),

	Filtering: type({
		FilteredWords: "(string >= 1)[]",
		ReplaceType: type.enumerated("Character", "Word"),
		ReplaceWith: "string",
	}),

	Gameservers: type({
		Hosting: type.enumerated("Selfhosted", "Dedicated", "Both"),
	}),

	Images: type({
		DefaultPlaceIcons: "(string >= 1)[]",
		DefaultPlaceThumbnails: "(string >= 1)[]",
	}),
	LauncherURI: "string >= 1",

	Logging: type({
		DiscordModerationWebhook: "string >= 1",
		FormattedErrors: "boolean",
		Requests: "boolean",
		Time: "boolean",
	}),
	Name: "string >= 1",

	Orbiter: type({
		PrivateURL: "string >= 1",
		PublicURL: "string >= 1",
	}),
	Pages: type.enumerated(...optionalPages).array(),
	RCCServiceProxyURL: "string >= 1",

	Registration: type({
		Emails: "boolean",
		Keys: type({
			Enabled: "boolean",
			Prefix: "string",
		}),
	}),

	Themes: type({
		Name: "string >= 1",
		Path: "string >= 1",
	})
		.array()
		.atLeastLength(1),
})

const parseResult = schema(rawconfig)
if (parseResult instanceof type.errors) {
	console.error("Configuration error in mercury.core.ts:")
	for (const error of parseResult)
		console.error(`    ${error.path.join(".")}: ${error.message}`)
	process.exit(1)
}

console.log("Successfully loaded configuration file")

const config = {
	...rawconfig,
	// Keep the other options' literal types, but let hosting be compared against any mode
	Gameservers: rawconfig.Gameservers as Config["Gameservers"],
} // lmfao
export default config
