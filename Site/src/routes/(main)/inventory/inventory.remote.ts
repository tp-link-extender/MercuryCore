import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { inventory } from "economy/api"
import type { CanOwnOne } from "economy/types"
import * as Econ from "economy/types"
import { getRequestEvent, query } from "$app/server"
import { authorise } from "$lib/server/auth"
import { db } from "$lib/server/surreal"
import queryGroups from "./groups.surql"
import queryPlaces from "./places.surql"
import querySources from "./sources.surql"
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

type Source = Asset

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

const getUnlimitedAssets = async () =>
	(await getInventory()).filter(i => i instanceof Econ.UnlimitedAsset)

export const getAsset = query(getAssetSchema, async t => {
	const is = await getUnlimitedAssets()

	await db.query<[Asset[]]>(queryUnlimitedAssets, { is })
})
export const getSources = query(async (): Promise<Source[]> => {
	const is = (await getInventory())
		.filter(
			i =>
				i instanceof Econ.LimitedSource ||
				i instanceof Econ.UnlimitedSource
		)
		.map(i => i.ID)

	await db.query<[Source[]]>(querySources, { is })
})

export const getGroups = query(async (): Promise<Group[]> => {
	const is = (await getInventory())
		.filter(i => i instanceof Econ.Group)
		.map(i => i.ID)

	await db.query(queryGroups, { is })
})
export const getPlaces = query(async (): Promise<Place[]> => {
	const is = (await getInventory())
		.filter(i => i instanceof Econ.Place)
		.map(i => i.ID)

	await db.query(queryPlaces, { is })
})
