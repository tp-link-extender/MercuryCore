// The following and members pages for a group.

import surql from "$lib/surrealtag"
import { squery } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"

export const load = async ({ params }) => {
	const group = (
		(await squery(
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
		)) as {
			memberCount: number
			members: {
				number: number
				username: string
			}[]
			name: string
		}[]
	)[0]

	if (!group) throw error(404, "Not found")

	return group
}
