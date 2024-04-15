import { authorise } from "$lib/server/lucia"
import ratelimit from "$lib/server/ratelimit"
import requestRender, { RenderType } from "$lib/server/requestRender"
import { squery, query, surql } from "$lib/server/surreal"
import { error, fail } from "@sveltejs/kit"
import fs from "node:fs/promises"
import type { RequestEvent } from "./$types"
import auditLog from "$lib/server/auditLog.surql"

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

export const load = async ({ locals }) => ({
	assets: await query<Asset>(import("./asset.surql"), {
		user: `user:${(await authorise(locals, 3)).user.id}`,
	}),
})

async function getData({ locals, url }: RequestEvent) {
	const { user } = await authorise(locals, 3)
	const id = url.searchParams.get("id")

	if (!id) error(400, "Missing asset id")
	if (!/^\d+$/.test(id)) error(400, `Invalid asset id: ${id}`)

	const params = {
		user: `user:${user.id}`,
		asset: `asset:${id}`,
	}
	const asset = await squery<{
		name: string
	}>(surql`SELECT name FROM $asset`, params)

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
	await squery(
		surql`
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
	await squery(
		surql`
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
		await requestRender(RenderType.Clothing, +id)
	} catch (e) {
		console.error(e)
		fail(500, { msg: "Failed to request render" })
	}
}
actions.purge = async e => {
	// Nuclear option
	const { id, params, assetName } = await getData(e)
	const { iaid } = await squery<{ iaid: number }>(
		surql`
			SELECT meta::id((->imageAsset->asset.id)[0]) AS iaid
			FROM $asset`,
		{ asset: `asset:${id}` }
	)

	await Promise.all([
		query(
			surql`
				DELETE $asset;
				DELETE $imageAsset;
				${auditLog}`,
			{
				...params,
				imageAsset: `asset:${iaid}`,
				action: "Moderation",
				note: `Purge asset ${assetName} (id ${id})`,
			}
		),
		fs.rm(`data/assets/${id}`),
		fs.rm(`data/assets/${iaid}`),
		fs.rm(`data/thumbnails/${id}`),
	])
}
