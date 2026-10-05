import fs from "node:fs"
import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { authorise } from "$lib/server/auth"
import formError from "$lib/server/formError"
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
import { arktype, message, superValidate } from "$lib/server/validate"
import { encode } from "$lib/urlName"
import assetQuery from "./asset.surql"
import assetCheckQuery from "./assetCheck.surql"
import reuploadQuery from "./reupload.surql"
import updateAssetQuery from "./updateAsset.surql"

type Asset = {
	id: string
	created: Date
	creator: BasicUser
	description: string
	forSale: boolean
	name: string
	price: number
	type: number
	visibility: string
}

const schema = type({
	// This is how I show my love
	// I made it in my mind because
	// I blame it on my ADD, baby
	name: "3 <= string <= 50",
	description: "(0 <= string <= 1000) | undefined",
	price: "0 <= number.integer <= 999",
	forSale: "boolean",
})

const reuploadSchema = type({
	asset: "File",
})

export async function load({ locals, params }) {
	const { user } = await authorise(locals)
	const id = +params.id
	const [[asset]] = await db.query<Asset[][]>(assetQuery, {
		asset: Record("asset", id),
		user: Record("user", user.id),
	})
	if (!asset) error(404, "Not Found")

	return {
		...asset,
		slug: encode(asset.name),
		settingsForm: await superValidate(
			{
				name: asset.name,
				forSale: asset.forSale,
				description: asset.description,
				price: asset.price,
			},
			arktype(schema)
		),
		reuploadForm: await superValidate(arktype(reuploadSchema)),
	}
}

export const actions: import("./$types").Actions = {}

type AssetCheck = {
	isCreator: boolean
	imageAssetId: number | null
	type: number
	name: string
}

actions.settings = async ({ locals, params, request }) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, arktype(schema))
	if (!form.valid) return formError(form)

	const id = +params.id
	const [[asset]] = await db.query<AssetCheck[][]>(assetCheckQuery, {
		asset: Record("asset", id),
		user: Record("user", user.id),
	})
	if (!asset) error(404, "Not Found")
	if (!asset.isCreator && user.permissionLevel < 4)
		error(403, "You do not have permission to edit this asset")

	await db.query(updateAssetQuery, {
		asset: Record("asset", id),
		...form.data,
	})

	return message(form, "Asset data updated successfully!")
}

// the approval rule matches asset creation: regular users go to the review queue, catalog managers and above (permissionLevel 3+) skip approval.
// this stops users from replacing their approved asset with new content to bypass moderation.
actions.reupload = async ({
	fetch: f,
	locals,
	params,
	request,
	getClientAddress,
}) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, arktype(reuploadSchema))
	if (!form.valid) return formError(form)

	const { asset: file } = form.data
	form.data.asset = null as unknown as File // make sure to return as a POJO

	if (file.size === 0)
		return formError(form, ["asset"], ["You must upload an asset"])
	if (file.size > 20e6)
		return formError(
			form,
			["asset"],
			["Asset must be less than 20MB in size"]
		)

	const id = +params.id
	const [[asset]] = await db.query<AssetCheck[][]>(assetCheckQuery, {
		asset: Record("asset", id),
		user: Record("user", user.id),
	})
	if (!asset) error(404, "Not Found")
	if (!asset.isCreator && user.permissionLevel < 4)
		error(403, "You do not have permission to edit this asset")

	if (user.permissionLevel < 3) {
		const limit = ratelimit(form, "assetReupload", getClientAddress, 30)
		if (limit) return limit
	}

	if (!fs.existsSync("../data/assets")) fs.mkdirSync("../data/assets")
	if (!fs.existsSync("../data/thumbnails")) fs.mkdirSync("../data/thumbnails")

	let saveImages: ((id: number) => Promise<number> | Promise<void>)[] = []

	try {
		switch (asset.type) {
			case 2: {
				// T-Shirt
				const [save, saveThumb] = await Promise.all([
					tShirt(file),
					tShirtThumbnail(await file.arrayBuffer()),
				])
				saveImages = [save, saveThumb]
				break
			}

			case 11:
			case 12: {
				// Shirt / Pants
				const save = await clothingAsset(file)
				saveImages = [
					save,
					(id: number) => requestRender(f, "Clothing", id),
				]
				break
			}

			case 13:
			case 18: {
				// Decal / Face
				const [save, saveThumb] = await Promise.all([
					imageAsset(file),
					thumbnail(await file.arrayBuffer()),
				])
				saveImages = [save, saveThumb]
				break
			}

			default: {
				// staff uploads (hats, gear, models etc.) are raw files with no linked image asset
				const buf = await file.arrayBuffer()
				saveImages = [
					(id: number) => Bun.write(`../data/assets/${id}`, buf),
				]
				break
			}
		}
	} catch (e) {
		console.log(e)
		return formError(form, ["asset"], ["Asset failed to upload"])
	}

	const visibility = user.permissionLevel >= 3 ? "Visible" : "Pending"
	await db.query(reuploadQuery, {
		asset: Record("asset", id),
		visibility,
		note: `Reupload asset ${asset.name} (id ${id})`,
		user: Record("user", user.id),
	})

	try {
		const imageId = asset.imageAssetId ?? id
		await Promise.all([saveImages[0](imageId), saveImages[1]?.(id)])
	} catch (e) {
		console.log("Updating images failed!")
		console.error(e)
	}

	return message(
		form,
		user.permissionLevel >= 3
			? "Asset reuploaded and approved successfully!"
			: "Asset reuploaded and is pending approval!"
	)
}
