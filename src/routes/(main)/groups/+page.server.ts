import surql from "$lib/surrealtag"
import { squery } from "$lib/server/surreal"

type Groups = {
	name: string
	memberCount: number
}[]

export const load = () => ({
	groups: squery(surql`
		SELECT
			name,
			count(<-member) AS memberCount
		FROM group`) as Promise<Groups>,
})

export const actions = {
	default: async ({ request }) => ({
		places: (await squery(
			surql`
				SELECT
					name,
					count(<-member) AS memberCount
				FROM group
				WHERE string::lowercase($query) ∈ string::lowercase(name)`,
			{
				query: (await request.formData()).get("query") as string,
			},
		)) as Groups,
	}),
}
