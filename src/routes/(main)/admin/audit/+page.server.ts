import { authorise } from "$lib/server/lucia"

export async function load({ locals }) {
	await authorise(locals, 5)
}
