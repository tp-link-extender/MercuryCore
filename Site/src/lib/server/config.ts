import { brickColours } from "$lib/brickColours"
import { z } from "zod"
import rawconfig from "../../../../mercury.core.ts"

if (!process.versions.bun && !Bun) {
	const runtime = process.versions.node ? "Node" : "an incorrect runtime"
	console.error(
		`Bun not detected. Did you accidentally start Mercury Core with ${runtime}?`
	)
	process.exit(1)
}

const brickColourEnum = z.union([
	z.literal(1), // br
	z.literal(1), // uh
	...brickColours.map(c => z.literal(c)),
])

export const optionalPages = ["Statistics", "Groups", "Forum"] as const
export type OptionalPage = (typeof optionalPages)[number]

const schema = z.object({
	Name: z.string().min(1),
	Domain: z.string().min(1),
	DatabaseURL: z.string().min(1),
	RCCServiceProxyURL: z.string().min(1),
	LauncherURI: z.string().min(1),
	CurrencySymbol: z.string().min(1),
	Pages: z.array(z.enum(optionalPages)),

	DefaultBodyColors: z.object({
		Head: brickColourEnum,
		LeftArm: brickColourEnum,
		LeftLeg: brickColourEnum,
		RightArm: brickColourEnum,
		RightLeg: brickColourEnum,
		Torso: brickColourEnum,
	}),

	Logging: z.object({
		Requests: z.boolean(),
		FormattedErrors: z.boolean(),
		Time: z.boolean(),
	}),

	Images: z.object({
		DefaultPlaceIcons: z.array(z.string().min(1)),
		DefaultPlaceThumbnails: z.array(z.string().min(1)),
	}),

	Branding: z.object({
		Favicon: z.string().min(1),
		Icon: z.string().min(1),
		Tagline: z.string(),
	}),

	Themes: z
		.array(
			z.object({
				Name: z.string().min(1),
				Path: z.string().min(1),
			})
		)
		.min(1),

	Filtering: z.object({
		FilteredWords: z.array(z.string().min(1)),
		ReplaceWith: z.string(),
		ReplaceType: z.enum(["Character", "Word"]),
	}),

	RegistrationKeys: z.object({
		Enabled: z.boolean(),
	}),
})

const parseResult = schema.safeParse(rawconfig)
if (!parseResult.success) {
	console.error("Configuration error in mercury.core.ts:")
	for (const error of parseResult.error.errors)
		console.error(`    ${error.path.join(".")}: ${error.message}`)
	process.exit(1)
}

console.log("Successfully loaded configuration file")

const config = rawconfig // lmfao
export default config
