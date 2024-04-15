import { query } from "$lib/server/surreal"
import select from "./avatarshop.surql"

export const load = async () => ({
	assets: await query<{
		name: string
		price: number
		id: number
		type: number
	}>(select),
})

export const actions: import("./$types").Actions = {}
actions.default = async ({ request }) => ({
	assets: await query(select, {
		query: (await request.formData()).get("q") as string,
	}),
})
