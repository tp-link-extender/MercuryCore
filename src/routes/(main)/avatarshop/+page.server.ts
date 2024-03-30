import { query, surql } from "$lib/server/surreal"

const select = surql`
	SELECT
		meta::id(id) AS id,
		name,
		price,
		type
	FROM asset WHERE visibility = "Visible"`

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
	assets: await query(
		surql`${select}
			AND string::lowercase($query) INSIDE string::lowercase(name)`,
		{ query: (await request.formData()).get("q") as string }
	),
})
