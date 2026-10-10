import type { TransferWithID } from "economy/economy"
import * as Econ from "economy/types"
import type { GroupData, OwnerData, SourceData, UserData } from "$lib/economy"
import ownersQuery from "$lib/server/owners.surql"
import { db, Record } from "$lib/server/surreal"

export const economyConnFailed = "Cannot connect to Economy service"

export type ReturnValue<T> = Promise<{ ok: true; value: T } | { ok: false }>
export type ReturnErr = { ok: true } | { ok: false; msg: string }

// better code than previously... i guess. whatever
export async function ownerData(list: TransferWithID[]): Promise<OwnerData> {
	const owners = [
		...list.map(tf => tf.Transfer.Send0.Owner),
		...list.map(tf => tf.Transfer.Send1.Owner),
	].filter(o => o !== null)

	const [users, groups, sources] = await db.query<
		[UserData[], GroupData[], SourceData[]]
	>(ownersQuery, {
		usersList: owners
			.filter(o => o instanceof Econ.User)
			.map(u => Record("user", u.ID)),
		groupsList: owners
			.filter(o => o instanceof Econ.Group)
			.map(g => Record("group", g.ID)),
		assetsList: owners
			.filter(Econ.IsSource)
			.map(s => Record("asset", s.ID)),
	})

	return {
		users: Object.fromEntries(users.map(u => [u.id, u])),
		groups: Object.fromEntries(groups.map(g => [g.id, g])),
		sources: Object.fromEntries(sources.map(s => [s.id, s])),
	}
}
