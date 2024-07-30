import { brickColours } from "$lib/brickColours"
import { z } from "zod"
import rawconfig from "../../../../mercury.core.ts"

const brickColourEnum = z.union([
	z.literal(1), // br
	z.literal(1), // uh
	...brickColours.map(c => z.literal(c)),
])

const schema = z.object({
	Name: z.string().min(1),
	Domain: z.string().min(1),
	DatabaseURL: z.string().min(1),
	RCCServiceProxyURL: z.string().min(1),
	CurrencySymbol: z.string().min(1),

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
