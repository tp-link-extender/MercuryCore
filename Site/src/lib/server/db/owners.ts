import type { GroupData, SourceData, UserData } from "#lib/economy.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import { Record, type RecordId } from "#lib/server/surreal.ts"
import ownersQuery from "./owners/records.surql"
import ownerUserQuery from "./owners/user.surql"

/** A user as an owner is shown: who they are and whether they're online. */
export type OwnerUser = BasicUser & { id: string }

/**
 * Finds a user as an owner is shown.
 * @returns The user, or null if there is no such user.
 */
export async function ownerUserOf(id: string): Promise<OwnerUser | null> {
	const [[user]] = await dbQuery<OwnerUser[][]>(ownerUserQuery, {
		user: Record("user", id),
	})
	return user ?? null
}

/** Finds how to show the users, groups and assets that own items. */
export function ownerRecordsOf(args: {
	assets: RecordId<"asset">[]
	groups: RecordId<"group">[]
	users: RecordId<"user">[]
}): Promise<[UserData[], GroupData[], SourceData[]]> {
	return dbQuery<[UserData[], GroupData[], SourceData[]]>(ownersQuery, {
		assetsList: args.assets,
		groupsList: args.groups,
		usersList: args.users,
	})
}
