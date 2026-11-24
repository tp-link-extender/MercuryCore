import fs from "node:fs"
import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { createUnlimitedSource, createUnlimitedSourceFree } from "economy/api"
import { User } from "economy/types"
import { typeToNumber } from "#lib/assetTypes.ts"
import { authorise } from "#lib/server/auth.ts"
import { createAsset } from "#lib/server/db/catalog.ts"
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
import { graphicAsset } from "#lib/server/xmlAsset.ts"
import { encode } from "#lib/urlName.ts"
import type { ClientForm } from "#lib/validate.ts"
import { form, getRequestEvent } from "$app/server"
import assetTypes from "./assetTypes"

const schema = type({
	asset: formFile,
	"description?": "0 <= string <= 1000",
	name: "3 <= string <= 50",
	price: "0 <= number.integer <= 999",
	// Object.keys(assets) doesn't work
	type: type
		.enumerated(...assetTypes)
		// TODO: compare with the other method in admin creation flow
		.configure({
			problem: "must be a valid asset type",
		}),
})

export const formData: ClientForm<typeof schema.infer> = form(
	schema,
	async ({ type: assetType, name, description, price, asset }, issues) => {
		const { fetch: f, locals, getClientAddress } = getRequestEvent()
		const { user } = await authorise(locals)

		if (asset.size === 0) return issues.asset("You must upload an asset")
		if (asset.size > 20e6)
			return issues.asset("Asset must be less than 20MB in size")

		if (user.permissionLevel < 3) {
			const limit = ratelimitRemote(
				issues,
				"assetCreation",
				getClientAddress,
				30
			)
			if (limit) return limit
		}

		if (!fs.existsSync("../data/assets")) fs.mkdirSync("../data/assets")
		if (!fs.existsSync("../data/thumbnails"))
			fs.mkdirSync("../data/thumbnails")

		// Read the upload into memory before charging, so a failed read leaves the user uncharged
		let buf: ArrayBuffer
		try {
			buf = await asset.arrayBuffer()
		} catch (e) {
			console.error(e)
			return issues.asset("Asset failed to upload")
		}

		let saveImages: ((id: number) => Promise<number> | Promise<void>)[] = []
		let render: ((id: number) => Promise<void>) | undefined

		try {
			switch (assetType) {
				case "T-Shirt":
					saveImages = await Promise.all([
						tShirt(asset),
						tShirtThumbnail(buf),
					])
					break

				case "Shirt":
				case "Pants":
					saveImages[0] = await clothingAsset(asset)
					render = id => requestRender(f, "Clothing", id)
					break

				case "Decal":
					saveImages = await Promise.all([
						imageAsset(asset),
						thumbnail(buf),
					])
					break

				case "Face":
					if (user.permissionLevel < 3)
						return issues.type(
							"You do not have permission to upload this type of asset"
						)
					saveImages = await Promise.all([
						imageAsset(asset),
						thumbnail(buf),
					])
					break
				default:
			}
		} catch (e) {
			console.error(e)
			return issues.asset("Asset failed to upload")
		}

		const u = new User(user.id)

		// Staff creation is free, since the Economy has no permission model of its own
		const createSource =
			user.permissionLevel >= 3
				? createUnlimitedSourceFree
				: createUnlimitedSource

		// A failure after this point leaves the sources owned by the user, with no way to refund them yet. A refund route in the Economy is the proper fix.
		const createdImageAsset = await createSource(f, u)
		if (!createdImageAsset.ok)
			return issues("Failed to create image asset source")

		const createdAsset = await createSource(f, u)
		if (!createdAsset.ok) return issues("Failed to create asset source")

		const imageAssetId = createdImageAsset.value.ID
		const id = createdAsset.value.ID

		let stored = false
		try {
			stored = await createAsset({
				assetType: typeToNumber[assetType],
				description,
				id,
				imageAssetId,
				name,
				price,
				visibility: user.permissionLevel < 3 ? "Pending" : "Visible",
			})
		} catch (e) {
			console.error(e)
		}
		if (!stored) return issues("Failed to create asset")

		try {
			await graphicAsset(assetType, imageAssetId, id)
			await Promise.all([
				saveImages[0](imageAssetId),
				saveImages[1]?.(id),
			])
		} catch (e) {
			console.error("Saving asset files failed")
			console.error(e)
			return issues("Failed to save asset files")
		}

		// A render request is best effort, as the asset is already usable without it
		if (render)
			try {
				await render(id)
			} catch (e) {
				console.error("Rendering images failed!")
				console.error(e)
			}

		redirect(302, `/catalog/${id}/${encode(name)}`)
	}
)
