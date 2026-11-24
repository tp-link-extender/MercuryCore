import { dbQuery } from "#lib/server/db/query.ts"
import { Record } from "#lib/server/surreal.ts"
import ownedQuery from "./groups/owned.surql"

export interface OwnedGroup {
	id: string
	memberCount: number
	name: string
}

/**
 * Finds the groups with these ids, with how many members each has.
 * @returns The groups that exist.
 */
export async function ownedGroupsOf(ids: string[]): Promise<OwnedGroup[]> {
	const [groups] = await dbQuery<OwnedGroup[][]>(ownedQuery, {
		ids: ids.map(id => Record("group", id)),
	})
	return groups
}
