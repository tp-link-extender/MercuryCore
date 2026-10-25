import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { inventory } from "economy/api"
import type { CanOwnOne } from "economy/types"
import * as Econ from "economy/types"
import { getRequestEvent, query } from "$app/server"
import { authorise } from "$lib/server/auth"
import { db, Record } from "$lib/server/surreal"
import queryGroups from "./groups.surql"
import queryPlaces from "./places.surql"
import queryUnlimitedAssets from "./unlimitedAssets.surql"

const getAssetSchema = type("number")

async function getInventory(): Promise<CanOwnOne[]> {
	const { fetch: f, locals } = getRequestEvent()

	const { user } = await authorise(locals)

	const u = new Econ.User(user.id)
	const inv = await inventory(f, u)
	if (!inv.ok) throw error(500, "failed to fetch inventory")

	return [...inv.value.One]
}

type Asset = {
	id: number
	name: string
	price: number
	type: number
}

type AssetBigInt = {
	id: number
	name: string
	price: bigint
	type: number
}

type Group = {
	id: string
	name: string
	memberCount: number
}

type Place = {
	id: number
	name: string
	likeCount: number
	dislikeCount: number
	playerCount: number
}

const assetToBigInt = (a: Asset): AssetBigInt => ({
	...a,
	price: BigInt(a.price),
})

async function getUnlimitedAssets(): Promise<AssetBigInt[]> {
	const ids = (await getInventory())
		.filter(i => i instanceof Econ.UnlimitedAsset)
		.map(i => Record("asset", i.ID))

	const [assets] = await db.query<[Asset[]]>(queryUnlimitedAssets, { ids })
	return assets.map(assetToBigInt)
}

export const getAsset = query(getAssetSchema, async t =>
	(await getUnlimitedAssets()).filter(a => a.type === t)
)

export const getSources = query(async (): Promise<AssetBigInt[]> => {
	const ids = (await getInventory())
		.filter(
			i =>
				i instanceof Econ.LimitedSource ||
				i instanceof Econ.UnlimitedSource
		)
		.map(i => Record("asset", i.ID))

	const [sources] = await db.query<[Asset[]]>(queryUnlimitedAssets, { ids })
	return sources.map(assetToBigInt)
})

export const getGroups = query(async (): Promise<Group[]> => {
	const ids = (await getInventory())
		.filter(i => i instanceof Econ.Group)
		.map(i => Record("group", i.ID))

	const [groups] = await db.query<[Group[]]>(queryGroups, { ids })
	return groups
})
export const getPlaces = query(async (): Promise<Place[]> => {
	const ids = (await getInventory())
		.filter(i => i instanceof Econ.Place)
		.map(i => Record("place", i.ID))

	const [places] = await db.query<[Place[]]>(queryPlaces, { ids })
	return places
})
