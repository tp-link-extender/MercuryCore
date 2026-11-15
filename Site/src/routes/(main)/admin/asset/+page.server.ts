import { error } from "@sveltejs/kit"
import { authorise } from "$lib/server/auth"
import {
	assetOwner,
	economyConnFailed,
	type OwnedUser,
} from "$lib/server/economy"
import { db } from "$lib/server/surreal"
import type { PageServerLoadEvent } from "./$types"
import assetsQuery from "./asset.surql"

interface Asset {
	id: number
	imageAsset?: {
		id: number
		name: string
	}
	name: string
	owner: OwnedUser | null
	price: number
	type: number
}

export async function load({ fetch: f, locals }: PageServerLoadEvent) {
	await authorise(locals, 3)

	const [assets] = await db.query<Asset[][]>(assetsQuery)

	const withOwners = await Promise.all(
		assets.map(async asset => {
			const owner = await assetOwner(f, asset.id, asset.type)
			if (!owner.ok) error(500, economyConnFailed)
			return Object.assign(asset, { owner: owner.value })
		})
	)

	return { assets: withOwners }
}
