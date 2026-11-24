import fs from "node:fs/promises"
import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { authorise } from "#lib/server/auth.ts"
import {
	assetFind,
	imageAssetIdOf,
	purgeAsset,
	setAssetVisibility,
} from "#lib/server/db/catalog.ts"
import { ratelimitRemote } from "#lib/server/ratelimit.ts"
import requestRender from "#lib/server/requestRender.ts"
import { Record } from "#lib/server/surreal.ts"
import { form, getRequestEvent } from "$app/server"

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
	const asset = await assetFind(assetId)
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
	await setAssetVisibility({
		...params,
		note: `Approve asset ${assetName} (id ${assetId})`,
		visibility: "Visible",
	})
})

export const denyForm = form(schema, async ({ id }) => {
	const { assetName, id: assetId, params } = await getData(id)
	await setAssetVisibility({
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
	const iaid = await imageAssetIdOf(assetId)

	// staff-created assets have no linked image asset, which leaves iaid undefined and would make an invalid record id.
	// 0 is never a real asset id, so deleting it does nothing
	const imageAsset = Record("asset", iaid ?? 0)

	// The records go first, so a missing file can't fail the purge after the asset is already gone
	await purgeAsset({
		...params,
		imageAsset,
		note: `Purge asset ${assetName} (id ${assetId})`,
	})
	const paths = [`../data/assets/${assetId}`, `../data/thumbnails/${assetId}`]
	if (iaid !== undefined) paths.push(`../data/assets/${iaid}`)
	await Promise.all(paths.map(path => fs.rm(path, { force: true })))
})
