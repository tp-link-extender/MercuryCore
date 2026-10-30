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

async function ownerUser(id: string): Promise<OwnedUser | null> {
	const [[user]] = await db.query<OwnedUser[][]>(ownerUserQuery, {
		user: Record("user", id),
	})
	return user ?? null
}

async function itemOwnerSeen(
	f: typeof globalThis.fetch,
	i: Econ.CanOwnOne,
	seen: Set<number>
): Promise<ReturnValue<OwnedUser | null>> {
	const owners = await ownersOne(f, i)
	if (!owners.ok) return { ok: false }

	const list = [...owners.value.set]

	// a user owner resolves directly; a package source owner means the item is nested inside a bundle
	const user = list.find(o => o instanceof Econ.User)
	if (user) return { ok: true, value: await ownerUser(user.ID) }

	const pkg = list.find(o => o instanceof Econ.PackageSource)
	if (pkg) {
		if (seen.has(pkg.ID)) return { ok: true, value: null }
		seen.add(pkg.ID)
		return itemOwnerSeen(f, pkg, seen)
	}

	return { ok: true, value: null }
}

/** Resolves the owning user of an item from the Economy service, or null if nobody owns it. */
export async function itemOwner(
	f: typeof globalThis.fetch,
	i: Econ.CanOwnOne
): Promise<ReturnValue<OwnedUser | null>> {
	return itemOwnerSeen(f, i, new Set())
}

/**
 * Resolves an asset's owner from the source that issues it.
 * Packages use a package source; other assets normally use an unlimited source, with a limited-source fallback.
 */
export async function assetOwner(
	f: typeof globalThis.fetch,
	id: number,
	type: number
): Promise<ReturnValue<OwnedUser | null>> {
	if (type === 32) return itemOwner(f, new Econ.PackageSource(id))

	const unlimited = await itemOwner(f, new Econ.UnlimitedSource(id))
	if (!unlimited.ok) return unlimited
	if (unlimited.value) return unlimited

	return itemOwner(f, new Econ.LimitedSource(id))
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
