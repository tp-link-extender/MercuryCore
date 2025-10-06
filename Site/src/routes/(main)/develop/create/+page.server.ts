import fs from "node:fs"
import { error, redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { arktype } from "sveltekit-superforms/adapters"
import { superValidate } from "sveltekit-superforms/server"
import { authorise } from "$lib/server/auth"
import { createAsset, getAssetPrice } from "$lib/server/economy"
import formError from "$lib/server/formError"
import { randomAssetId } from "$lib/server/id"
import {
	clothingAsset,
	imageAsset,
	thumbnail,
	tShirt,
	tShirtThumbnail,
} from "$lib/server/imageAsset"
import ratelimit from "$lib/server/ratelimit"
import requestRender from "$lib/server/requestRender"
import { db, Record } from "$lib/server/surreal"
import { graphicAsset } from "$lib/server/xmlAsset"
import { encode } from "$lib/urlName"
import createAssetQuery from "./createAsset.surql"

const schema = type({
	// Object.keys(assets) doesn't work
	type: type.enumerated(2, 8, 11, 12, 13, 18).configure({
		problem: "must be a valid asset type",
	}),
	name: "3 <= string <= 50",
	description: "(0 <= string <= 1000) | undefined",
	price: "0 <= number.integer <= 999",
	asset: "File",
})

export async function load({ url }) {
	const price = getAssetPrice()
	return {
		form: await superValidate(arktype(schema)),
		assetType: url.searchParams.get("asset"),
		price,
	}
}

const assets: { [k: number]: string } = Object.freeze({
	2: "T-Shirt",
	11: "Shirt",
	12: "Pants",
	13: "Decal",
})
export const actions: import("./$types").Actions = {}
actions.default = async ({ locals, request, getClientAddress }) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, arktype(schema))
	if (!form.valid) return formError(form)

	const { type, name, description, price, asset } = form.data
	const assetType = +type as keyof typeof assets
	form.data.asset = null // make sure to return as a POJO

	if (asset.size === 0)
		return formError(form, ["asset"], ["You must upload an asset"])
	if (asset.size > 20e6)
		return formError(
			form,
			["asset"],
			["Asset must be less than 20MB in size"]
		)

	const limit = ratelimit(form, "assetCreation", getClientAddress, 30)
	if (limit) return limit

	if (!fs.existsSync("../data/assets")) fs.mkdirSync("../data/assets")
	if (!fs.existsSync("../data/thumbnails")) fs.mkdirSync("../data/thumbnails")

	let saveImages: ((id: number) => Promise<number> | Promise<void>)[] = []

	try {
		switch (assetType) {
			case 2: // T-Shirt
				saveImages = await Promise.all([
					tShirt(asset),
					tShirtThumbnail(await asset.arrayBuffer()),
				])
				break

			case 11: // Shirt
			case 12: // Pants
				saveImages[0] = await clothingAsset(asset)
				saveImages[1] = (id: number) => requestRender("Clothing", id)
				break

			case 13: // Decal
				saveImages = await Promise.all([
					imageAsset(asset),
					thumbnail(asset),
				])
				break

			case 18: // Face
				if (user.permissionLevel < 3)
					return formError(
						form,
						["type"],
						[
							"You do not have permission to upload this type of asset",
						]
					)
				saveImages = await Promise.all([
					imageAsset(asset),
					thumbnail(asset),
				])
				break
			default:
		}
	} catch (e) {
		console.log(e)
		return formError(form, ["asset"], ["Asset failed to upload"])
	}

	const slug = encode(name)
	const imageAssetId = randomAssetId()
	const id = randomAssetId()

	const created = await createAsset(user.id, id, name, slug)
	if (!created.ok) return formError(form, ["other"], [created.msg])

	await db.query(createAssetQuery, {
		name,
		assetType,
		price,
		description,
		user: Record("user", user.id),
		imageAssetId,
		id,
	})

	await graphicAsset(assets[assetType], imageAssetId, id)

	try {
		await saveImages[0](imageAssetId)
		await saveImages[1](id)
	} catch (e) {
		console.log("Rendering images failed!")
		console.error(e)
	}

	redirect(302, `/catalog/${id}/${name}`)
}
