import fs from "node:fs/promises"
import { error, fail } from "@sveltejs/kit"
import { assetRegex } from "$lib/paramTests"
import { authorise } from "$lib/server/auth"
import {
	assetOwner,
	economyConnFailed,
	type OwnedUser,
} from "$lib/server/economy"
import ratelimit from "$lib/server/ratelimit"
import requestRender from "$lib/server/requestRender"
import { db, Record } from "$lib/server/surreal"
import type { Actions, PageServerLoadEvent } from "./$types"
import type { RequestEvent } from "./$types.d"
import assetsQuery from "./asset.surql"
import iaidQuery from "./iaid.surql"
import purgeQuery from "./purge.surql"
import visibilityQuery from "./visibility.surql"

type Asset = {
	name: string
	price: number
	id: number
	type: number
	owner: OwnedUser | null
	imageAsset?: {
		id: number
		name: string
	}
}

export async function load({ fetch: f, locals }: PageServerLoadEvent) {
	await authorise(locals, 3)

	const [assets] = await db.query<Asset[][]>(assetsQuery)

	const withOwners = await Promise.all(
		assets.map(async asset => {
			const owner = await assetOwner(f, asset.id, asset.type)
			if (!owner.ok) error(500, economyConnFailed)
			return { ...asset, owner: owner.value }
		})
	)

	return { assets: withOwners }
}

async function getData({ locals, url }: RequestEvent) {
	const { user } = await authorise(locals, 3)
	const assetId = url.searchParams.get("id")

	if (!assetId) error(400, "Missing asset ID")
	if (!assetRegex.test(assetId)) error(400, `Invalid asset ID: ${assetId}`)
	const id = Number(assetId)

	const params = Object.freeze({
		asset: Record("asset", id),
		user: Record("user", user.id),
	})
	const [[asset]] = await db.query<{ name: string }[][]>(
		"SELECT name FROM $asset",
		params
	)
	if (!asset) error(404, "Asset not found")

	return { assetName: asset.name, id, params, user }
}

// it goes like this, the bug, the fix
// the pull request, the git commit
// the coder's late-night screams
// of hallelujah
export const actions: Actions = {}
actions.approve = async e => {
	const { id, params, assetName } = await getData(e)
	await db.query(visibilityQuery, {
		...params,
		note: `Approve asset ${assetName} (id ${id})`,
		visibility: "Visible",
	})
}
actions.deny = async e => {
	const { id, params, assetName } = await getData(e)
	await db.query(visibilityQuery, {
		...params,
		note: `Moderate asset ${assetName} (id ${id})`,
		visibility: "Moderated",
	})
}
actions.rerender = async e => {
	const { id } = await getData(e)
	const limit = ratelimit(null, "rerender", e.getClientAddress, 10)
	if (limit) return limit

	try {
		await requestRender(e.fetch, "Clothing", id)
	} catch (e) {
		console.error(e)
		fail(500, { msg: "Failed to request render" })
	}
}
actions.purge = async e => {
	// Nuclear option
	const { id, params, assetName } = await getData(e)
	const [[{ iaid }]] = await db.query<{ iaid: number }[][]>(iaidQuery, {
		asset: Record("asset", id),
	})

	await Promise.all([
		db.query(purgeQuery, {
			...params,
			imageAsset: Record("asset", iaid),
			note: `Purge asset ${assetName} (id ${id})`,
		}),
		fs.rm(`../data/assets/${id}`),
		fs.rm(`../data/assets/${iaid}`),
		fs.rm(`../data/thumbnails/${id}`),
	])
}
