// Utilities for working with packages (asset type 32)
// A package's contents live in the Economy service, not the database: the package source holds the source for each of its contents, and can report them flattened however deeply they nest.

import { inventory, packageContents } from "economy/api"
import type { CanOwnOne } from "economy/types"
import * as Econ from "economy/types"
import { economyConnFailed } from "$lib/server/economy"
import { db, Record } from "$lib/server/surreal"
import query from "./packageItems.surql"

export type PackageItem = {
	id: number
	name: string
	type: number
	visibility: string
	owned: boolean
}

/** An item type the Economy service can report ownership of. */
type OwnedItem = CanOwnOne & { ID: number }

const isOwnedItem = (i: Econ.Item): i is OwnedItem =>
	i instanceof Econ.UnlimitedAsset || i instanceof Econ.Package

const itemIds = (items: ItemsOneLike): number[] =>
	[...items.set].filter(isOwnedItem).map(i => i.ID)

type ItemsOneLike = { set: Set<Econ.Item> }

// The Economy service is the only authority on who owns what, so ownership for the whole bundle is resolved in one inventory read rather than a query per item.
async function ownedIds(
	f: typeof globalThis.fetch,
	userId: string
): Promise<Set<number>> {
	const inv = await inventory(f, new Econ.User(userId))
	if (!inv.ok) throw new Error(economyConnFailed)

	return new Set(itemIds(inv.value.One))
}

/**
 * Returns every asset a package contains, including everything inside nested packages.
 * @param f fetch, for talking to the Economy service.
 * @param id The id of the package asset, which is also its package source id.
 * @param userId The id of the user, to determine whether they own each item. Omit to leave
 * ownership unresolved, for callers with no user or that don't need it.
 * @returns A flat list of package items, excluding the package itself.
 */
export async function packageItems(
	f: typeof globalThis.fetch,
	id: number,
	userId?: string
): Promise<PackageItem[]> {
	const [contents, owned] = await Promise.all([
		packageContents(f, new Econ.PackageSource(id)),
		userId ? ownedIds(f, userId) : undefined,
	])
	if (!contents.ok) throw new Error(economyConnFailed)

	// the ledger reports the package itself first; the caller only wants what's inside it
	const ids = itemIds(contents.value).filter(itemId => itemId !== id)
	if (!ids.length) return []

	// the ledger knows which assets exist, the database knows their name, type and visibility
	const [rows] = await db.query<Omit<PackageItem, "owned">[][]>(query, {
		ids: ids.map(id => Record("asset", id)),
	})

	return rows.map(row => ({ ...row, owned: owned?.has(row.id) ?? false }))
}
