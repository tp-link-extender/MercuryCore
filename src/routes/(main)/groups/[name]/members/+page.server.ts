// The member page for a group.

import surql from "$lib/surrealtag"
import { query } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"

export const load = async ({ params }) => {
	const group = (
		await query<{
			memberCount: number
			members: {
				number: number
				username: string
			}[]
			name: string
		}>(
			surql`
			SELECT
				name,
				count(<-member) AS memberCount,
				(SELECT
					number,
					username
				FROM <-member<-user) AS members
			FROM group WHERE string::lowercase(name)
				= string::lowercase($name)`,
			params,
		)
	)[0]

	if (!group) throw error(404, "Not found")

	return group
}
