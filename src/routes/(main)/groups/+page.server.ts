import { query, surql } from "$lib/server/surreal"

type Group = {
	name: string
	memberCount: number
}

const select = surql`SELECT name, count(<-member) AS memberCount FROM group`

export const load = async () => ({
	groups: await query<Group>(select),
})

export const actions = {
	default: async ({ request }) => ({
		groups: await query<Group>(
			surql`${select}
				WHERE string::lowercase($query) INSIDE string::lowercase(name)`,
			{ query: (await request.formData()).get("q") as string }
		),
	}),
}
