import fs from "node:fs/promises"
import { intRegex } from "$lib/paramTests"
import { authorise } from "$lib/server/lucia"
import ratelimit from "$lib/server/ratelimit"
import requestRender from "$lib/server/requestRender"
import { Record, db } from "$lib/server/surreal"
import { error, fail } from "@sveltejs/kit"
import type { RequestEvent } from "./$types.d.ts"
import assetsQuery from "./asset.surql"
import iaidQuery from "./iaid.surql"
import purgeQuery from "./purge.surql"
import visibilityQuery from "./visibility.surql"

type Asset = {
	name: string
	price: number
	id: number
	type: string
	creator: BasicUser
	imageAsset?: {
		id: number
		name: string
	}
}

export async function load({ locals }) {
	const { user } = await authorise(locals, 3)

	const [assets] = await db.query<Asset[][]>(assetsQuery, {
		user: Record("user", user.id),
	})
	return { assets }
}

async function getData({ locals, url }: RequestEvent) {
	const { user } = await authorise(locals, 3)
	const id = url.searchParams.get("id")

	if (!id) error(400, "Missing asset id")
	if (!intRegex.test(id)) error(400, `Invalid asset id: ${id}`)

	const params = {
		user: Record("user", user.id),
		asset: Record("asset", +id),
	}
	const [[asset]] = await db.query<{ name: string }[][]>(
		"SELECT name FROM $asset",
		params
	)
	if (!asset) error(404, "Asset not found")

	return { user, id, params, assetName: asset.name }
}

// it goes like this, the bug, the fix
// the pull request, the git commit
// the coder's late-night screams
// of hallelujah
export const actions: import("./$types").Actions = {}
actions.approve = async e => {
	const { id, params, assetName } = await getData(e)
	await db.query(visibilityQuery, {
		...params,
		visibility: "Visible",
		note: `Approve asset ${assetName} (id ${id})`,
	})
}
actions.deny = async e => {
	const { id, params, assetName } = await getData(e)
	await db.query(visibilityQuery, {
		...params,
		visibility: "Moderated",
		note: `Moderate asset ${assetName} (id ${id})`,
	})
}
actions.rerender = async e => {
	const { id } = await getData(e)
	const limit = ratelimit(null, "rerender", e.getClientAddress, 10)
	if (limit) return limit

	try {
		await requestRender("Clothing", +id)
	} catch (e) {
		console.error(e)
		fail(500, { msg: "Failed to request render" })
	}
}
actions.purge = async e => {
	// Nuclear option
	const { id, params, assetName } = await getData(e)
	const [[{ iaid }]] = await db.query<{ iaid: number }[][]>(iaidQuery, {
		asset: Record("asset", +id),
	})

	await Promise.all([
		db.query(purgeQuery, {
			...params,
			note: `Purge asset ${assetName} (id ${id})`,
			imageAsset: Record("asset", iaid),
		}),
		fs.rm(`../data/assets/${id}`),
		fs.rm(`../data/assets/${iaid}`),
		fs.rm(`../data/thumbnails/${id}`),
	])
}
