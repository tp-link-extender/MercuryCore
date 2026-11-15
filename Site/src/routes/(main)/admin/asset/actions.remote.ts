import fs from "node:fs/promises"
import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { form, getRequestEvent } from "$app/server"
import { authorise } from "$lib/server/auth"
import { ratelimitRemote } from "$lib/server/ratelimit"
import requestRender from "$lib/server/requestRender"
import { db, Record } from "$lib/server/surreal"
import iaidQuery from "./iaid.surql"
import purgeQuery from "./purge.surql"
import visibilityQuery from "./visibility.surql"

// Catalog Managers (level 3) review the pending queue. Acting on an asset that's already been reviewed, such as making a moderated asset visible again or purging a visible one, needs a Moderator (level 4).
const reviewedLevel = 4

// Asset ids are numbers, so `.for()` instances send a number
const assetIdSchema = type("string | number").pipe(String)

const schema = type({
	id: assetIdSchema,
})

async function getData(id: string) {
	const { locals } = getRequestEvent()
	const { user } = await authorise(locals, 3)

	const assetId = Number(id)
	if (!Number.isInteger(assetId)) error(400, `Invalid asset ID: ${id}`)

	const params = Object.freeze({
		asset: Record("asset", assetId),
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

	return { assetName: asset.name, id: assetId, params }
}

export const approveForm = form(schema, async ({ id }) => {
	const { assetName, id: assetId, params } = await getData(id)
	await db.query(visibilityQuery, {
		...params,
		note: `Approve asset ${assetName} (id ${assetId})`,
		visibility: "Visible",
	})
})

export const denyForm = form(schema, async ({ id }) => {
	const { assetName, id: assetId, params } = await getData(id)
	await db.query(visibilityQuery, {
		...params,
		note: `Moderate asset ${assetName} (id ${assetId})`,
		visibility: "Moderated",
	})
})

export const rerenderForm = form(schema, async ({ id }, issues) => {
	const { fetch: f, getClientAddress } = getRequestEvent()
	const { id: assetId } = await getData(id)

	const limit = ratelimitRemote(issues, "rerender", getClientAddress, 10)
	if (limit) return limit

	try {
		await requestRender(f, "Clothing", assetId)
	} catch (err) {
		console.error(err)
		error(500, "Failed to request render")
	}
})

export const purgeForm = form(schema, async ({ id }) => {
	// Nuclear option
	const { assetName, id: assetId, params } = await getData(id)
	const [[{ iaid }]] = await db.query<{ iaid: number }[][]>(iaidQuery, {
		asset: Record("asset", assetId),
	})

	// The records go first, so a missing file can't fail the purge after the asset is already gone
	await db.query(purgeQuery, {
		...params,
		imageAsset: Record("asset", iaid),
		note: `Purge asset ${assetName} (id ${assetId})`,
	})
	await Promise.all(
		[
			`../data/assets/${assetId}`,
			`../data/assets/${iaid}`,
			`../data/thumbnails/${assetId}`,
		].map(path => fs.rm(path, { force: true }))
	)
})
