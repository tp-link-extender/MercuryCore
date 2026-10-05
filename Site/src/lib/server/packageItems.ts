// Utilities for working with packages (asset type 32)

import { db, Record } from "$lib/server/surreal"
import query from "./packageItems.surql"

export type PackageItem = {
	id: number
	type: number
	visibility: string
	owned: boolean
	nested: number
}

/**
 * Returns every asset that a package contains, recursively (nested packages included).
 * @param id The id of the package asset.
 * @param userId The id of the user, to determine whether they own each item.
 * @returns A flat list of package items.
 */
export async function packageItems(
	id: number,
	userId: string
): Promise<PackageItem[]> {
	const items: PackageItem[] = []
	const seen = new Set<number>([id])

	// packages shouldn't nest this deep, but cycles should be guarded against anyway
	let frontier = [id]
	for (let depth = 0; depth < 5 && frontier.length; depth++) {
		const next = []
		for (const pkg of frontier) {
			const [rows] = await db.query<PackageItem[][]>(query, {
				pkg: Record("asset", pkg),
				user: Record("user", userId),
			})
			for (const row of rows)
				if (!seen.has(row.id)) {
					seen.add(row.id)
					items.push(row)
					if (row.nested > 0) next.push(row.id)
				}
		}
		frontier = next
	}

	return items
}
