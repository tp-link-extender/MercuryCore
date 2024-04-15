import { authorise } from "$lib/server/lucia"
import { query } from "$lib/server/surreal"
import select from "./inventory.surql"

export const load = async ({ locals, url }) => {
	const searchQ = url.searchParams.get("q")?.trim()

	return {
		query: searchQ,
		assets: await query<{
			name: string
			price: number
			id: number
			type: number
		}>(select, {
			query: searchQ,
			user: `user:${(await authorise(locals)).user.id}`,
		}),
	}
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ request, locals }) => ({
	assets: await query(select, {
		query: (await request.formData()).get("q") as string,
		user: `user:${(await authorise(locals)).user.id}`,
	}),
})
