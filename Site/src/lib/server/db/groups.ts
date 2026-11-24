import { dbQuery } from "#lib/server/db/query.ts"
import { Record, type RecordId } from "#lib/server/surreal.ts"
import createQuery from "./groups/create.surql"
import groupQuery from "./groups/group.surql"
import joinQuery from "./groups/join.surql"
import leaveQuery from "./groups/leave.surql"
import listQuery from "./groups/list.surql"
import membersQuery from "./groups/members.surql"
import ownedQuery from "./groups/owned.surql"

export interface GroupListing {
	id: string
	memberCount: number
	name: string
}

export interface GroupPage extends GroupListing {
	in: boolean
}

export interface GroupMembers {
	memberCount: number
	members: BasicUser[]
	name: string
}

/**
 * Lists a page of groups, most members first.
 * @returns The groups on the page, and how many pages there are.
 */
export async function groupsPage(
	page: number
): Promise<{ groups: GroupListing[]; pages: number }> {
	const [groups, pages] = await dbQuery<[GroupListing[], number]>(listQuery, {
		page,
	})
	return { groups, pages }
}

/**
 * Finds a group, and whether the viewer is a member of it.
 * @returns The group, or undefined if there is no such group.
 */
export async function groupOf(
	id: string,
	viewer: RecordId<"user">
): Promise<GroupPage | undefined> {
	const [[group]] = await dbQuery<GroupPage[][]>(groupQuery, {
		group: Record("group", id),
		user: viewer,
	})
	return group
}

/**
 * Finds a group and its members.
 * @returns The group, or undefined if there is no such group.
 */
export async function groupMembersOf(
	id: string
): Promise<GroupMembers | undefined> {
	const [[group]] = await dbQuery<GroupMembers[][]>(membersQuery, {
		group: Record("group", id),
	})
	return group
}

/**
 * Finds the groups with these ids, with how many members each has.
 * @returns The groups that exist.
 */
export async function ownedGroupsOf(ids: string[]): Promise<GroupListing[]> {
	const [groups] = await dbQuery<GroupListing[][]>(ownedQuery, {
		ids: ids.map(id => Record("group", id)),
	})
	return groups
}

/**
 * Creates a group, owned by the user who created it.
 * @param economyId The id the Economy service issued, which the group's record uses so ownership can be resolved from the ledger.
 */
export async function createGroupRecord(
	economyId: string,
	name: string,
	owner: RecordId<"user">
): Promise<void> {
	await dbQuery(createQuery, { economyId, name, user: owner })
}

/** Makes a user a member of a group. Joining again does nothing. */
export async function joinGroup(
	group: RecordId<"group">,
	user: RecordId<"user">
): Promise<void> {
	await dbQuery(joinQuery, { group, user })
}

export async function leaveGroup(
	group: RecordId<"group">,
	user: RecordId<"user">
): Promise<void> {
	await dbQuery(leaveQuery, { group, user })
}
