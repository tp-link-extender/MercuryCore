import fs from "node:fs"
import formError from "$lib/server/formError"
import {
	clothingAsset,
	imageAsset,
	tShirt,
	tShirtThumbnail,
	thumbnail,
} from "$lib/server/imageAsset"
import { authorise } from "$lib/server/lucia"
import ratelimit from "$lib/server/ratelimit"
import requestRender from "$lib/server/requestRender"
import { Record, equery } from "$lib/server/surreal"
import { graphicAsset } from "$lib/server/xmlAsset"
import { redirect } from "@sveltejs/kit"
import { zod } from "sveltekit-superforms/adapters"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"
import createAssetQuery from "./createAsset.surql"

const schema = z.object({
	// Object.keys(assets) doesn't work
	type: z.enum(["2", "8", "11", "12", "13", "18"]),
	name: z.string().min(3).max(50),
	description: z.string().max(1000).optional(),
	price: z.number().int().min(0).max(999),
	asset: z.any(),
})

export const load = async ({ request }) => ({
	form: await superValidate(zod(schema)),
	assettype: new URL(request.url).searchParams.get("asset"),
})

const assets: { [k: number]: string } = Object.freeze({
	2: "T-Shirt",
	11: "Shirt",
	12: "Pants",
	13: "Decal",
})

export const actions: import("./$types").Actions = {}
actions.default = async ({ request, locals, getClientAddress }) => {
	const { user } = await authorise(locals)
	const formData = await request.formData()
	const form = await superValidate(formData, zod(schema))
	if (!form.valid) return formError(form)

	const { type, name, description, price } = form.data
	const assetType = +type as keyof typeof assets
	const asset = formData.get("asset") as File

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

	if (!fs.existsSync("data/assets")) fs.mkdirSync("data/assets")
	if (!fs.existsSync("data/thumbnails")) fs.mkdirSync("data/thumbnails")

	let saveImages: ((id: number) => Promise<number> | Promise<void>)[] = []

	try {
		switch (assetType) {
			case 2: // T-Shirt
				saveImages = await Promise.all([
					tShirt(asset),
					tShirtThumbnail(asset),
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

	const res = await equery<number[]>(createAssetQuery, {
		name,
		assetType,
		price,
		description,
		user: Record("user", user.id),
	})

	const imageAssetId = res[9]
	const id = res[10] // concurrency issues fixed hopefully

	await graphicAsset(assets[assetType], imageAssetId, id)

	try {
		await saveImages[0](imageAssetId)
		await saveImages[1](id)
	} catch (e) {
		console.log("Rendering images failed!")
		console.error(e)
	}

	redirect(302, `/avatarshop/${id}/${name}`)
}
