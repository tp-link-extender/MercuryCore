import { equery, surql } from "$lib/server/surreal"

export type Group = {
	name: string
	memberCount: number
}

export async function load() {
	const [groups] = await equery<Group[][]>(
		surql`SELECT name, count(<-member) AS memberCount FROM group`
	)
	return { groups }
}
