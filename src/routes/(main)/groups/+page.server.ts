import { equery, surrealql } from "$lib/server/surreal"

type Group = {
	name: string
	memberCount: number
}

export async function load() {
	const [groups] = await equery<Group[][]>(
		surrealql`SELECT name, count(<-member) AS memberCount FROM group`
	)

	return { groups }
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ request }) => {
	const q = (await request.formData()).get("q")
	const [groups] = await equery<Group[][]>(
		surrealql`
			SELECT name, count(<-member) AS memberCount FROM group
			WHERE string::lowercase(${q}) IN string::lowercase(name)`
	)

	return { groups }
}
