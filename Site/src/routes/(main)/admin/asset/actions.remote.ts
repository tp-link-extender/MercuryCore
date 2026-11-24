import fs from "node:fs/promises"
import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { authorise } from "#lib/server/auth.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import { ratelimitRemote } from "#lib/server/ratelimit.ts"
import requestRender from "#lib/server/requestRender.ts"
import { Record } from "#lib/server/surreal.ts"
import { form, getRequestEvent } from "$app/server"
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
	const [[asset]] = await dbQuery<
		{ name: string; type: number; visibility: string }[][]
	>("SELECT name, type, visibility FROM $asset", params)
	if (!asset) error(404, "Asset not found")
	if (asset.visibility !== "Pending" && user.permissionLevel < reviewedLevel)
		error(
			403,
			"Only moderators can act on assets that have already been reviewed"
		)

	return { assetName: asset.name, assetType: asset.type, id: assetId, params }
}

export const approveForm = form(schema, async ({ id }) => {
	const { assetName, id: assetId, params } = await getData(id)
	await dbQuery(visibilityQuery, {
		...params,
		note: `Approve asset ${assetName} (id ${assetId})`,
		visibility: "Visible",
	})
})

export const denyForm = form(schema, async ({ id }) => {
	const { assetName, id: assetId, params } = await getData(id)
	await dbQuery(visibilityQuery, {
		...params,
		note: `Moderate asset ${assetName} (id ${assetId})`,
		visibility: "Moderated",
	})
})

export const rerenderForm = form(schema, async ({ id }, issues) => {
	const { fetch: f, getClientAddress } = getRequestEvent()
	const { assetType, id: assetId } = await getData(id)

	// only shirts and pants have an RCC clothing render.
	// t-shirts, decals and faces have their thumbnails written directly at creation, so rendering them as clothing would overwrite the wrong image
	if (![11, 12].includes(assetType))
		return issues("Only shirts and pants can be rerendered")

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
	const [[{ iaid }]] = await dbQuery<{ iaid: number }[][]>(iaidQuery, {
		asset: Record("asset", assetId),
	})

	// staff-created assets have no linked image asset, which leaves iaid undefined and would make an invalid record id.
	// 0 is never a real asset id, so deleting it does nothing
	const imageAsset = Record("asset", iaid ?? 0)

	// The records go first, so a missing file can't fail the purge after the asset is already gone
	await dbQuery(purgeQuery, {
		...params,
		imageAsset,
		note: `Purge asset ${assetName} (id ${assetId})`,
	})
	const paths = [`../data/assets/${assetId}`, `../data/thumbnails/${assetId}`]
	if (iaid !== undefined) paths.push(`../data/assets/${iaid}`)
	await Promise.all(paths.map(path => fs.rm(path, { force: true })))
})
