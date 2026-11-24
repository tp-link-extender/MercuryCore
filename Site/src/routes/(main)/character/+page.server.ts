import { error } from "@sveltejs/kit"
import { inventory } from "economy/api"
import type { ItemsOne } from "economy/items"
import {
	Package as EconPackage,
	UnlimitedAsset as EconUnlimitedAsset,
	User as EconUser,
} from "economy/types"
import { allowedTypes, packageWearable } from "#lib/character.ts"
import { authorise } from "#lib/server/auth.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import { economyConnFailed } from "#lib/server/economy.ts"
import { packageItems } from "#lib/server/packageItems.ts"
import { Record } from "#lib/server/surreal.ts"
import type { PageServerLoadEvent } from "./$types"
import assetsQuery from "./assets.surql"
import wornQuery from "./worn.surql"

export interface Asset {
	id: number
	name: string
	price: number
	type: number
	wearing: boolean
}

const ownedAssetIds = (items: ItemsOne) =>
	[...items.set]
		.filter(
			i => i instanceof EconUnlimitedAsset || i instanceof EconPackage
		)
		.map(i => i.ID)

async function getOwnedAssetIds(f: typeof globalThis.fetch, userId: string) {
	const inv = await inventory(f, new EconUser(userId))
	if (!inv.ok) error(500, economyConnFailed)

	return ownedAssetIds(inv.value.One)
}

interface WornAsset {
	id: number
	worn: boolean
}

export async function load({ fetch: f, locals }: PageServerLoadEvent) {
	const { user } = await authorise(locals)
	const ids = await getOwnedAssetIds(f, user.id)

	if (ids.length === 0) return { assets: [] }

	const [assets] = await dbQuery<Asset[][]>(assetsQuery, {
		allowedTypes,
		assets: ids.map(id => Record("asset", id)),
		user: Record("user", user.id),
	})

	// A package counts as worn when every item inside it is worn, so that
	// unequipping anything from it removes its wearing state
	const contents = new Map<number, number[]>()
	const wearables: number[] = []
	for (const asset of assets.filter(a => a.type === 32)) {
		const items = (await packageItems(f, asset.id, user.id)).filter(
			i =>
				i.owned &&
				i.visibility === "Visible" &&
				packageWearable.includes(i.type)
		)
		if (items.length > 0) {
			contents.set(
				asset.id,
				items.map(i => i.id)
			)
			wearables.push(...items.map(i => i.id))
		}
	}

	if (wearables.length > 0) {
		const [worn] = await dbQuery<WornAsset[][]>(wornQuery, {
			ids: wearables,
			user: Record("user", user.id),
		})
		const wornIds = new Set(worn.filter(w => w.worn).map(w => w.id))
		for (const [pkgId, items] of contents) {
			const pkg = assets.find(a => a.id === pkgId)
			if (pkg && items.every(id => wornIds.has(id))) pkg.wearing = true
		}
	}

	return { assets }
}
