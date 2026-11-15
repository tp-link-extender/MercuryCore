import fs from "node:fs/promises"
import { error, fail } from "@sveltejs/kit"
import { assetRegex } from "$lib/paramTests"
import { authorise } from "$lib/server/auth"
import {
	assetOwner,
	economyConnFailed,
	type OwnedUser,
} from "$lib/server/economy"
import { ratelimit } from "$lib/server/ratelimit"
import requestRender from "$lib/server/requestRender"
import { db, Record } from "$lib/server/surreal"
import type { Actions, PageServerLoadEvent } from "./$types"
import type { RequestEvent } from "./$types.d"
import assetsQuery from "./asset.surql"
import iaidQuery from "./iaid.surql"
import purgeQuery from "./purge.surql"
import visibilityQuery from "./visibility.surql"

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

// Catalog Managers (level 3) review the pending queue. Acting on an asset that's already been reviewed, such as making a moderated asset visible again or purging a visible one, needs a Moderator (level 4).
const reviewedLevel = 4

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
	const [[asset]] = await db.query<{ name: string; visibility: string }[][]>(
		"SELECT name, visibility FROM $asset",
		params
	)
	if (!asset) error(404, "Asset not found")
	if (asset.visibility !== "Pending" && user.permissionLevel < reviewedLevel)
		error(
			403,
			"Only moderators can act on assets that have already been reviewed"
		)

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
	const limit = ratelimit("rerender", e.getClientAddress, 10)
	if (limit) return limit

	try {
		await requestRender(e.fetch, "Clothing", id)
	} catch (err) {
		console.error(err)
		return fail(500, { msg: "Failed to request render" })
	}
}
actions.purge = async e => {
	// Nuclear option
	const { id, params, assetName } = await getData(e)
	const [[{ iaid }]] = await db.query<{ iaid: number }[][]>(iaidQuery, {
		asset: Record("asset", id),
	})

	// The records go first, so a missing file can't fail the purge after the asset is already gone
	await db.query(purgeQuery, {
		...params,
		imageAsset: Record("asset", iaid),
		note: `Purge asset ${assetName} (id ${id})`,
	})
	await Promise.all(
		[
			`../data/assets/${id}`,
			`../data/assets/${iaid}`,
			`../data/thumbnails/${id}`,
		].map(path => fs.rm(path, { force: true }))
	)
}
