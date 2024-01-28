import { authorise } from "$lib/server/lucia"
import { z } from "zod"
import { superValidate } from "sveltekit-superforms/server"

const schema = z.object({
	// Object.keys(assets) doesn't work
	type: z.enum(["2", "8", "11", "12", "13", "18"]),
	name: z.string().min(3).max(50),
	description: z.string().max(1000).optional(),
	price: z.number().int().min(0).max(999),
	asset: z.any(),
})

// Make sure a user is an administrator before loading the page.
export async function load({ locals }) {
	await authorise(locals, 5)

	return {
		formManual: await superValidate(schema),
		formAuto: await superValidate(schema)
	}
}
