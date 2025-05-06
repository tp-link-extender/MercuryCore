import fs from "node:fs"
import { authorise } from "$lib/server/auth"
import { createAsset, getAssetPrice } from "$lib/server/economy"
import formError from "$lib/server/formError"
import {
	clothingAsset,
	imageAsset,
	tShirt,
	tShirtThumbnail,
	thumbnail,
} from "$lib/server/imageAsset"
import ratelimit from "$lib/server/ratelimit"
import requestRender from "$lib/server/requestRender"
import { Record, db } from "$lib/server/surreal"
import { graphicAsset } from "$lib/server/xmlAsset"
import { encode } from "$lib/urlName"
import { error, redirect } from "@sveltejs/kit"
import { zod } from "sveltekit-superforms/adapters"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"
import createAssetQuery from "./createAsset.surql"

const schema = z.object({
	// Object.keys(assets) doesn't work
	type: z.enum(["2", "8", "11", "12", "13", "18"], {
		message: "Select an asset type",
	}),
	name: z.string().min(3).max(50),
	description: z.string().max(1000).optional(),
	price: z.number().int().min(0).max(999),
	asset: z.any(),
})

export async function load({ url }) {
	const price = await getAssetPrice()
	if (!price.ok) error(500, price.msg)
	return {
		form: await superValidate(zod(schema)),
		assetType: url.searchParams.get("asset"),
		price: price.value,
	}
}

const assets: { [k: number]: string } = Object.freeze({
	2: "T-Shirt",
	11: "Shirt",
	12: "Pants",
	13: "Decal",
})

export const actions: import("./$types").Actions = {}
actions.default = async ({ request, locals, getClientAddress }) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, zod(schema))
	if (!form.valid) return formError(form)

	const { type, name, description, price } = form.data
	const assetType = +type as keyof typeof assets
	const asset = form.data.asset as File
	form.data.asset = null

	if (!asset || asset.size === 0)
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

	const [id] = await db.query<number[]>(
		"(UPDATE ONLY stuff:increment SET asset += 2).asset"
	)
	const imageAssetId = id - 1 // LOL, concurrency problems Solved!

	const slug = encode(name)
	const created = await createAsset(user.id, id, name, slug)
	if (!created.ok) {
		await db.query("UPDATE ONLY stuff:increment SET asset -= 2")
		return formError(form, ["other"], [created.msg])
	}

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
