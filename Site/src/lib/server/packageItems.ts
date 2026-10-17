// Utilities for working with packages (asset type 32)

import { inventory } from "economy/api"
import type { CanOwnOne } from "economy/types"
import * as Econ from "economy/types"
import { economyConnFailed } from "$lib/server/economy"
import { db, Record } from "$lib/server/surreal"
import query from "./packageItems.surql"

export type PackageItem = {
	id: number
	type: number
	visibility: string
	owned: boolean
	nested: number
}

/** An item type that the Economy service can report ownership of. */
type OwnedItem = CanOwnOne & { ID: number }

const isOwnedItem = (i: Econ.Item): i is OwnedItem =>
	i instanceof Econ.UnlimitedAsset || i instanceof Econ.Package

// The Economy service is the only authority on who owns what, so ownership for the whole bundle is resolved in one inventory read rather than a query per item.
async function ownedIds(
	f: typeof globalThis.fetch,
	userId: string
): Promise<Set<number>> {
	const inv = await inventory(f, new Econ.User(userId))
	if (!inv.ok) throw new Error(economyConnFailed)

	const owned = new Set<number>()
	for (const item of inv.value.One) if (isOwnedItem(item)) owned.add(item.ID)

	return owned
}

/**
 * Returns every asset that a package contains, recursively (nested packages included).
 * @param f fetch, for talking to the Economy service.
 * @param id The id of the package asset.
 * @param userId The id of the user, to determine whether they own each item. Omit to leave
 * ownership unresolved, for callers that don't have a user or don't need it.
 * @returns A flat list of package items.
 */
export async function packageItems(
	f: typeof globalThis.fetch,
	id: number,
	userId?: string
): Promise<PackageItem[]> {
	const owned = userId ? await ownedIds(f, userId) : undefined

	const items: PackageItem[] = []
	const seen = new Set<number>([id])

	// packages shouldn't nest this deep, but cycles should be guarded against anyway
	let frontier = [id]
	for (let depth = 0; depth < 5 && frontier.length; depth++) {
		const next: number[] = []
		for (const pkg of frontier) {
			const [rows] = await db.query<Omit<PackageItem, "owned">[][]>(
				query,
				{
					pkg: Record("asset", pkg),
				}
			)
			for (const row of rows)
				if (!seen.has(row.id)) {
					seen.add(row.id)
					items.push({ ...row, owned: owned?.has(row.id) ?? false })
					if (row.nested > 0) next.push(row.id)
				}
		}
		frontier = next
	}

	return items
}
