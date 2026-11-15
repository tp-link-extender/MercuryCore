import fs from "node:fs"
import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { authorise } from "$lib/server/auth"
import { assetOwner, economyConnFailed } from "$lib/server/economy"
import { isAudio, isImage, isMesh, isRobloxModel } from "$lib/server/fileType"
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
import type { Actions, PageServerLoadEvent } from "./$types"
import assetQuery from "./asset.surql"
import assetCheckQuery from "./assetCheck.surql"
import reuploadQuery from "./reupload.surql"
import updateAssetQuery from "./updateAsset.surql"

interface Asset {
	created: Date
	description: string
	forSale: boolean
	id: string
	imageAssetId: number | null
	name: string
	price: number
	type: number
	visibility: string
}

const schema = type({
	description: "(0 <= string <= 1000) | undefined",
	forSale: "boolean",
	// This is how I show my love
	// I made it in my mind because
	// I blame it on my ADD, baby
	name: "3 <= string <= 50",
	price: "0 <= number.integer <= 999",
})

const reuploadSchema = type({
	asset: "File",
})

export async function load({ fetch: f, locals, params }: PageServerLoadEvent) {
	const { user } = await authorise(locals)
	const id = Number(params.id)
	const [[check]] = await db.query<AssetCheck[][]>(assetCheckQuery, {
		asset: Record("asset", id),
	})
	if (!check) error(404, "Not Found")

	const owner = await assetOwner(f, id, check.type)
	if (!owner.ok) error(500, economyConnFailed)
	const isOwner = owner.value?.id === user.id
	if (!isOwner && user.permissionLevel < 3)
		error(403, "You do not have permission to view this page")

	const [[asset]] = await db.query<Asset[][]>(assetQuery, {
		asset: Record("asset", id),
	})
	if (!asset) error(404, "Not Found")

	return {
		...asset,
		reuploadForm: await superValidate(arktype(reuploadSchema)),
		settingsForm: await superValidate(
			{
				description: asset.description,
				forSale: asset.forSale,
				name: asset.name,
				price: asset.price,
			},
			arktype(schema)
		),
		slug: encode(asset.name),
	}
}

export const actions: Actions = {}

interface AssetCheck {
	imageAssetId: number | null
	name: string
	type: number
}

// Hats, gear, models, animations, heads and limbs
const modelTypes = Object.freeze(
	new Set([8, 10, 17, 19, 24, 25, 26, 27, 28, 29, 30, 31, 42])
)

/** Checks that a reuploaded file is the right kind for the asset's type. Returns why it isn't, or nothing if it is. */
async function reuploadProblem(
	asset: AssetCheck,
	file: File,
	buf: ArrayBuffer,
	permissionLevel: number
): Promise<string | undefined> {
	// items with textures (t-shirts, clothing, decals, faces) and images themselves must be actual images
	if (asset.imageAssetId || asset.type === 1)
		return (await isImage(file)) ? undefined : "File must be an image"
	// natively rich formats: only accept files whose magic bytes match the asset type
	if (asset.type === 3)
		return isAudio(buf) ? undefined : "File must be an audio file"
	if (asset.type === 4)
		return isMesh(buf) ? undefined : "File must be a mesh file"
	if (modelTypes.has(asset.type))
		return isRobloxModel(buf) || isMesh(buf)
			? undefined
			: "File must be a Roblox mesh or model file"
	// Other types (such as Lua or plugins) have no format to check, so only staff can replace them
	if (permissionLevel < 3) return "Only staff can reupload this type of asset"
}

actions.settings = async ({ fetch: f, locals, params, request }) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, arktype(schema))
	if (!form.valid) return formError(form)

	const id = Number(params.id)
	const [[asset]] = await db.query<AssetCheck[][]>(assetCheckQuery, {
		asset: Record("asset", id),
	})
	if (!asset) error(404, "Not Found")

	const owner = await assetOwner(f, id, asset.type)
	if (!owner.ok) error(500, economyConnFailed)
	if (owner.value?.id !== user.id && user.permissionLevel < 4)
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
	// oxlint-disable-next-line typescript/no-unsafe-type-assertion
	form.data.asset = null as unknown as File // make sure to return as a POJO

	if (file.size === 0)
		return formError(form, ["asset"], ["You must upload an asset"])
	if (file.size > 20e6)
		return formError(
			form,
			["asset"],
			["Asset must be less than 20MB in size"]
		)

	const id = Number(params.id)
	const [[asset]] = await db.query<AssetCheck[][]>(assetCheckQuery, {
		asset: Record("asset", id),
	})
	if (!asset) error(404, "Not Found")

	const owner = await assetOwner(f, id, asset.type)
	if (!owner.ok) error(500, economyConnFailed)
	if (owner.value?.id !== user.id && user.permissionLevel < 4)
		error(403, "You do not have permission to edit this asset")

	// packages are collections of assets and don't have a file of their own to replace
	if (asset.type === 32)
		return formError(form, ["asset"], ["Packages cannot be reuploaded"])

	const buf = await file.arrayBuffer()
	const problem = await reuploadProblem(
		asset,
		file,
		buf,
		user.permissionLevel
	)
	if (problem) return formError(form, ["asset"], [problem])

	if (user.permissionLevel < 3) {
		const limit = ratelimit(form, "assetReupload", getClientAddress, 30)
		if (limit) return limit
	}

	if (!fs.existsSync("../data/assets")) fs.mkdirSync("../data/assets")
	if (!fs.existsSync("../data/thumbnails")) fs.mkdirSync("../data/thumbnails")

	const jobs: Promise<unknown>[] = []

	try {
		switch (asset.type) {
			case 2: {
				// T-Shirt
				const [save, saveThumb] = await Promise.all([
					tShirt(file),
					tShirtThumbnail(buf),
				])
				jobs.push(save(asset.imageAssetId ?? id), saveThumb(id))
				break
			}

			case 11:
			case 12: {
				// Shirt / Pants
				const save = await clothingAsset(file)
				jobs.push(save(asset.imageAssetId ?? id))
				break
			}

			case 13:
			case 18: {
				// Decal / Face
				const [save, saveThumb] = await Promise.all([
					imageAsset(file),
					thumbnail(buf),
				])
				jobs.push(save(asset.imageAssetId ?? id), saveThumb(id))
				break
			}

			default: {
				// staff uploads (hats, gear, models etc.) are raw files with no linked image asset
				jobs.push(Bun.write(`../data/assets/${id}`, buf))
				break
			}
		}

		// write the new files before touching the database, so a failed upload doesn't update the asset
		await Promise.all(jobs)
	} catch (e) {
		console.log(e)
		return formError(form, ["asset"], ["Asset failed to upload"])
	}

	const visibility = user.permissionLevel >= 3 ? "Visible" : "Pending"
	await db.query(reuploadQuery, {
		asset: Record("asset", id),
		note: `Reupload asset ${asset.name} (id ${id})`,
		user: Record("user", user.id),
		visibility,
	})

	if ([11, 12].includes(asset.type))
		try {
			await requestRender(f, "Clothing", id)
		} catch (e) {
			console.log("Render request failed!")
			console.error(e)
		}

	return message(
		form,
		user.permissionLevel >= 3
			? "Asset reuploaded and approved successfully!"
			: "Asset reuploaded and is pending approval!"
	)
}
