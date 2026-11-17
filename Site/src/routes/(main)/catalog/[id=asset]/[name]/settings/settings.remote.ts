import fs from "node:fs"
import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { form, getRequestEvent } from "$app/server"
import { authorise } from "#lib/server/auth.ts"
import { assetOwner, economyConnFailed } from "#lib/server/economy.ts"
import { isAudio, isImage, isMesh, isRobloxModel } from "#lib/server/fileType.ts"
import filter from "#lib/server/filter.ts"
import { formFile } from "#lib/server/formFile.ts"
import {
	clothingAsset,
	imageAsset,
	thumbnail,
	tShirt,
	tShirtThumbnail,
} from "#lib/server/imageAsset.ts"
import { ratelimitRemote } from "#lib/server/ratelimit.ts"
import requestRender from "#lib/server/requestRender.ts"
import { db, Record } from "#lib/server/surreal.ts"
import type { ClientForm } from "#lib/validate.ts"
import assetCheckQuery from "./assetCheck.surql"
import reuploadQuery from "./reupload.surql"
import updateAssetQuery from "./updateAsset.surql"

interface AssetCheck {
	imageAssetId: number | null
	name: string
	type: number
}

const schema = type({
	"description?": "0 <= string <= 1000",
	"forSale?": "boolean",
	id: "string",
	// This is how I show my love
	// I made it in my mind because
	// I blame it on my ADD, baby
	name: "3 <= string <= 50",
	price: "0 <= number.integer <= 999",
})

const reuploadSchema = type({
	asset: formFile,
	id: "string",
})

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

export const settingsForm: ClientForm<typeof schema.infer> = form(
	schema,
	async ({ id, description, forSale, name, price }) => {
		const { fetch: f, locals } = getRequestEvent()
		const { user } = await authorise(locals)

		const assetId = Number(id)
		const [[asset]] = await db.query<AssetCheck[][]>(assetCheckQuery, {
			asset: Record("asset", assetId),
		})
		if (!asset) error(404, "Not Found")

		const owner = await assetOwner(f, assetId, asset.type)
		if (!owner.ok) error(500, economyConnFailed)
		if (owner.value?.id !== user.id && user.permissionLevel < 4)
			error(403, "You do not have permission to edit this asset")

		const review = user.permissionLevel < 3
		const results = await db.query(updateAssetQuery, {
			asset: Record("asset", assetId),
			description: filter(description || ""),
			forSale: Boolean(forSale),
			name: filter(name),
			price,
			review,
		})
		const changed = results.at(-1) === true

		return {
			success:
				changed && review
					? "Asset data updated and is pending approval!"
					: "Asset data updated successfully!",
		}
	}
)

// the approval rule matches asset creation: regular users go to the review queue, catalog managers and above (permissionLevel 3+) skip approval.
// this stops users from replacing their approved asset with new content to bypass moderation.
export const reuploadForm: ClientForm<typeof reuploadSchema.infer> = form(
	reuploadSchema,
	async ({ asset: file, id }, issues) => {
		const { fetch: f, locals, getClientAddress } = getRequestEvent()
		const { user } = await authorise(locals)

		if (file.size === 0) return issues.asset("You must upload an asset")
		if (file.size > 20e6)
			return issues.asset("Asset must be less than 20MB in size")

		const assetId = Number(id)
		const [[asset]] = await db.query<AssetCheck[][]>(assetCheckQuery, {
			asset: Record("asset", assetId),
		})
		if (!asset) error(404, "Not Found")

		const owner = await assetOwner(f, assetId, asset.type)
		if (!owner.ok) error(500, economyConnFailed)
		if (owner.value?.id !== user.id && user.permissionLevel < 4)
			error(403, "You do not have permission to edit this asset")

		// packages are collections of assets and don't have a file of their own to replace
		if (asset.type === 32)
			return issues.asset("Packages cannot be reuploaded")

		const buf = await file.arrayBuffer()
		const problem = await reuploadProblem(
			asset,
			file,
			buf,
			user.permissionLevel
		)
		if (problem) return issues.asset(problem)

		if (user.permissionLevel < 3) {
			const limit = ratelimitRemote(
				issues,
				"assetReupload",
				getClientAddress,
				30
			)
			if (limit) return limit
		}

		if (!fs.existsSync("../data/assets")) fs.mkdirSync("../data/assets")
		if (!fs.existsSync("../data/thumbnails"))
			fs.mkdirSync("../data/thumbnails")

		const jobs: Promise<unknown>[] = []

		try {
			switch (asset.type) {
				case 2: {
					// T-Shirt
					const [save, saveThumb] = await Promise.all([
						tShirt(file),
						tShirtThumbnail(buf),
					])
					jobs.push(
						save(asset.imageAssetId ?? assetId),
						saveThumb(assetId)
					)
					break
				}

				case 11:
				case 12: {
					// Shirt / Pants
					const save = await clothingAsset(file)
					jobs.push(save(asset.imageAssetId ?? assetId))
					break
				}

				case 13:
				case 18: {
					// Decal / Face
					const [save, saveThumb] = await Promise.all([
						imageAsset(file),
						thumbnail(buf),
					])
					jobs.push(
						save(asset.imageAssetId ?? assetId),
						saveThumb(assetId)
					)
					break
				}

				default: {
					// staff uploads (hats, gear, models etc.) are raw files with no linked image asset
					jobs.push(Bun.write(`../data/assets/${assetId}`, buf))
					break
				}
			}

			// write the new files before touching the database, so a failed upload doesn't update the asset
			await Promise.all(jobs)
		} catch (e) {
			console.log(e)
			return issues.asset("Asset failed to upload")
		}

		const visibility = user.permissionLevel >= 3 ? "Visible" : "Pending"
		await db.query(reuploadQuery, {
			asset: Record("asset", assetId),
			note: `Reupload asset ${asset.name} (id ${assetId})`,
			user: Record("user", user.id),
			visibility,
		})

		if ([11, 12].includes(asset.type))
			try {
				await requestRender(f, "Clothing", assetId)
			} catch (e) {
				console.log("Render request failed!")
				console.error(e)
			}

		return {
			success:
				user.permissionLevel >= 3
					? "Asset reuploaded and approved successfully!"
					: "Asset reuploaded and is pending approval!",
		}
	}
)
