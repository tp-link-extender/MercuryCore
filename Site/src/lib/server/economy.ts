import { ownersOne } from "economy/api"
import type { TransferWithID } from "economy/economy"
import * as Econ from "economy/types"
import type { GroupData, OwnerData, SourceData, UserData } from "$lib/economy"
import ownersQuery from "$lib/server/owners.surql"
import ownerUserQuery from "$lib/server/ownerUser.surql"
import { db, Record } from "$lib/server/surreal"

export const economyConnFailed = "Cannot connect to Economy service"

export type ReturnValue<T> = Promise<{ ok: true; value: T } | { ok: false }>
export type ReturnErr = { ok: true } | { ok: false; msg: string }

export type OwnedUser = BasicUser & { id: string }

/** Resolves the owning user of an item from the Economy service, or null if nobody owns it. */
export async function itemOwner(
	f: typeof globalThis.fetch,
	i: Econ.CanOwnOne
): Promise<ReturnValue<OwnedUser | null>> {
	const owners = await ownersOne(f, i)
	if (!owners.ok) return { ok: false }

	const owner = [...owners.value.set].find(o => o instanceof Econ.User)
	if (!owner) return { ok: true, value: null }

	const [[user]] = await db.query<OwnedUser[][]>(ownerUserQuery, {
		user: Record("user", owner.ID),
	})
	return { ok: true, value: user ?? null }
}

/** Whether a user owns an item, without resolving the owner's profile data. */
export async function ownsItem(
	f: typeof globalThis.fetch,
	userId: string,
	i: Econ.CanOwnOne
): Promise<ReturnValue<boolean>> {
	const owners = await ownersOne(f, i)
	if (!owners.ok) return { ok: false }

	return {
		ok: true,
		value: [...owners.value.set].some(
			o => o instanceof Econ.User && o.ID === userId
		),
	}
}

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
