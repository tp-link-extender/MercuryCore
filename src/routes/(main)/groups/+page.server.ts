import surql from "$lib/surrealtag"
import { query } from "$lib/server/surreal"

type Group = {
	name: string
	memberCount: number
}

export const load = () => ({
	groups: query<Group>(surql`
		SELECT
			name,
			count(<-member) AS memberCount
		FROM group`),
})

export const actions = {
	default: async ({ request }) => ({
		places: await query<Group>(
			surql`
				SELECT
					name,
					count(<-member) AS memberCount
				FROM group
				WHERE string::lowercase($query) ∈ string::lowercase(name)`,
			{ query: (await request.formData()).get("query") as string },
		),
	}),
}
