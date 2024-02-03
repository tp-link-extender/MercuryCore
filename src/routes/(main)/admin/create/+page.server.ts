import { authorise } from "$lib/server/lucia"
import { z } from "zod"
import { superValidate } from "sveltekit-superforms/server"

const schemaManual = z.object({
	type: z.enum(["8", "18"]),
	name: z.string().min(3).max(50),
	description: z.string().max(1000).optional(),
	price: z.number().int().min(0).max(999),
	asset: z.any(),
})
const schemaAuto = z.object({
	type: z.enum(["8"]),
	id: z.number(),
	name: z.string().min(3).max(50),
	description: z.string().max(1000).optional(),
	price: z.number().int().min(0).max(999),
})

// Make sure a user is an administrator before loading the page.
export async function load({ locals }) {
	await authorise(locals, 5)

	return {
		formManual: await superValidate(schemaManual),
		formAuto: await superValidate(schemaAuto),
	}
}
