import fs from "node:fs"
import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { typeToNumber } from "$lib/assetTypes"
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
import { arktype, superValidate } from "$lib/server/validate"
import { graphicAsset } from "$lib/server/xmlAsset"
import { encode } from "$lib/urlName"
import assetTypes from "./assetTypes"
import createAssetQuery from "./createAsset.surql"

const schema = type({
	// Object.keys(assets) doesn't work
	type: type.enumerated(...assetTypes).configure({
		problem: "must be a valid asset type",
	}),
	name: "3 <= string <= 50",
	description: "(0 <= string <= 1000) | undefined",
	price: "0 <= number.integer <= 999",
	asset: "File",
})

// type assetType = (typeof assetTypes)[number]

export async function load({ url }) {
	const price = getAssetPrice()
	// const urlType = url.searchParams.get("type") as assetType | null
	return {
		form: await superValidate(
			arktype(
				schema
				// probably not needed

				// {
				// 	defaults: {
				// 		// ...(urlType &&
				// 		// 	assetTypes.includes(urlType) && { type: urlType }),
				// 		type:
				// 			urlType && assetTypes.includes(urlType)
				// 				? urlType
				// 				: assetTypes[0],
				// 		name: "",
				// 		description: "",
				// 		price: 0,
				// 		asset: null as unknown as File,
				// 	},
				// }
			)
		),
		assetType: url.searchParams.get("asset"),
		price,
	}
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ fetch: f, locals, request, getClientAddress }) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, arktype(schema))
	if (!form.valid) return formError(form)

	const { type, name, description, price, asset } = form.data
	form.data.asset = null as unknown as File // make sure to return as a POJO

	if (asset.size === 0)
		return formError(form, ["asset"], ["You must upload an asset"])
	if (asset.size > 20e6)
		return formError(
			form,
			["asset"],
			["Asset must be less than 20MB in size"]
		)

	if (user.permissionLevel < 3) {
		const limit = ratelimit(form, "assetCreation", getClientAddress, 30)
		if (limit) return limit
	}

	if (!fs.existsSync("../data/assets")) fs.mkdirSync("../data/assets")
	if (!fs.existsSync("../data/thumbnails")) fs.mkdirSync("../data/thumbnails")

	let saveImages: ((id: number) => Promise<number> | Promise<void>)[] = []

	try {
		switch (type) {
			case "T-Shirt":
				saveImages = await Promise.all([
					tShirt(asset),
					tShirtThumbnail(await asset.arrayBuffer()),
				])
				break

			case "Shirt":
			case "Pants":
				saveImages[0] = await clothingAsset(asset)
				saveImages[1] = (id: number) => requestRender(f, "Clothing", id)
				break

			case "Decal":
				saveImages = await Promise.all([
					imageAsset(asset),
					thumbnail(await asset.arrayBuffer()),
				])
				break

			case "Face":
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
					thumbnail(await asset.arrayBuffer()),
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

	if (user.permissionLevel < 3) {
		const created = await createAsset(f, user.id, id, name, slug)
		if (!created.ok) return formError(form, ["other"], [created.msg])
	}

	await db.query(createAssetQuery, {
		name,
		assetType: typeToNumber[type],
		price,
		description,
		user: Record("user", user.id),
		imageAssetId,
		id,
		visibility: user.permissionLevel < 3 ? "Pending" : "Visible",
	})

	await graphicAsset(type, imageAssetId, id)

	try {
		await Promise.all([saveImages[0](imageAssetId), saveImages[1](id)])
	} catch (e) {
		console.log("Rendering images failed!")
		console.error(e)
	}

	redirect(302, `/catalog/${id}/${name}`)
}
