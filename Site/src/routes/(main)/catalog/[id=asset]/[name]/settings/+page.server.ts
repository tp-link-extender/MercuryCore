import { error } from "@sveltejs/kit"
import { authorise } from "#lib/server/auth.ts"
import { assetOwner, economyConnFailed } from "#lib/server/economy.ts"
import { db, Record } from "#lib/server/surreal.ts"
import { encode } from "#lib/urlName.ts"
import type { PageServerLoadEvent } from "./$types"
import assetQuery from "./asset.surql"
import assetCheckQuery from "./assetCheck.surql"

interface Asset {
	created: Date
	description: string
	forSale: boolean
	id: string
	imageAssetId: number | null
	name: string
	price: number
	type: number
	visibility: string
}

interface AssetCheck {
	imageAssetId: number | null
	name: string
	type: number
}

export async function load({ fetch: f, locals, params }: PageServerLoadEvent) {
	const { user } = await authorise(locals)
	const id = Number(params.id)
	const [[check]] = await db.query<AssetCheck[][]>(assetCheckQuery, {
		asset: Record("asset", id),
	})
	if (!check) error(404, "Not Found")

	const owner = await assetOwner(f, id, check.type)
	if (!owner.ok) error(500, economyConnFailed)
	const isOwner = owner.value?.id === user.id
	if (!isOwner && user.permissionLevel < 3)
		error(403, "You do not have permission to view this page")

	const [[asset]] = await db.query<Asset[][]>(assetQuery, {
		asset: Record("asset", id),
	})
	if (!asset) error(404, "Not Found")

	return {
		...asset,
		slug: encode(asset.name),
	}
}
