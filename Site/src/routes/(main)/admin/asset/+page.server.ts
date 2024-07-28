import fs from "node:fs/promises"
import { intRegex } from "$lib/paramTests"
import auditLog from "$lib/server/auditLog.surql"
import { authorise } from "$lib/server/lucia"
import ratelimit from "$lib/server/ratelimit"
import requestRender from "$lib/server/requestRender"
import { Record, equery, surql } from "$lib/server/surreal"
import { error, fail } from "@sveltejs/kit"
import type { RequestEvent } from "./$types.d.ts"
import assetsQuery from "./asset.surql"

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
	const [assets] = await equery<Asset[][]>(assetsQuery, {
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
	const [[asset]] = await equery<{ name: string }[][]>(
		surql`SELECT name FROM $asset`,
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
	await equery(
		`
			UPDATE $asset SET visibility = "Visible";
			UPDATE $asset->imageAsset->asset SET visibility = "Visible";
			${auditLog}`,
		{
			...params,
			action: "Moderation",
			note: `Approve asset ${assetName} (id ${id})`,
		}
	)
}
actions.deny = async e => {
	const { id, params, assetName } = await getData(e)
	await equery(
		`
			UPDATE $asset SET visibility = "Moderated";
			UPDATE $asset->imageAsset->asset SET visibility = "Moderated";
			${auditLog}`,
		{
			...params,
			action: "Moderation",
			note: `Moderate asset ${assetName} (id ${id})`,
		}
	)
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
	const [[{ iaid }]] = await equery<{ iaid: number }[][]>(
		surql`
			SELECT meta::id((->imageAsset->asset.id)[0]) AS iaid
			FROM ${Record("asset", +id)}`
	)

	await Promise.all([
		equery(
			`
				DELETE $asset;
				DELETE $imageAsset;
				${auditLog}`,
			{
				...params,
				imageAsset: Record("asset", iaid),
				action: "Moderation",
				note: `Purge asset ${assetName} (id ${id})`,
			}
		),
		fs.rm(`data/assets/${id}`),
		fs.rm(`data/assets/${iaid}`),
		fs.rm(`data/thumbnails/${id}`),
	])
}