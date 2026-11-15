import fs from "node:fs"
import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { createUnlimitedSource } from "economy/api"
import { User } from "economy/types"
import { form, getRequestEvent } from "$app/server"
import { typeToNumber } from "$lib/assetTypes"
import { authorise } from "$lib/server/auth"
import {
	clothingAsset,
	imageAsset,
	thumbnail,
	tShirt,
	tShirtThumbnail,
} from "$lib/server/imageAsset"
import { ratelimitRemote } from "$lib/server/ratelimit"
import requestRender from "$lib/server/requestRender"
import { db } from "$lib/server/surreal"
import { graphicAsset } from "$lib/server/xmlAsset"
import { encode } from "$lib/urlName"
import type { ClientForm } from "$lib/validate"
import assetTypes from "./assetTypes"
import createAssetQuery from "./createAsset.surql"

const schema = type({
	asset: "File",
	description: "(0 <= string <= 1000) | undefined",
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

		let saveImages: ((id: number) => Promise<number> | Promise<void>)[] = []

		try {
			switch (assetType) {
				case "T-Shirt":
					saveImages = await Promise.all([
						tShirt(asset),
						tShirtThumbnail(await asset.arrayBuffer()),
					])
					break

				case "Shirt":
				case "Pants":
					saveImages[0] = await clothingAsset(asset)
					saveImages[1] = (id: number) =>
						requestRender(f, "Clothing", id)
					break

				case "Decal":
					saveImages = await Promise.all([
						imageAsset(asset),
						thumbnail(await asset.arrayBuffer()),
					])
					break

				case "Face":
					if (user.permissionLevel < 3)
						return issues.type(
							"You do not have permission to upload this type of asset"
						)
					saveImages = await Promise.all([
						imageAsset(asset),
						thumbnail(await asset.arrayBuffer()),
					])
					break
				default:
			}
		} catch (e) {
			console.error(e)
			return issues.asset("Asset failed to upload")
		}

		const u = new User(user.id)

		// TODO: make creating image assets (only image assets) free
		const createdImageAsset = await createUnlimitedSource(f, u)
		if (!createdImageAsset.ok)
			return issues("Failed to create image asset source")

		const createdAsset = await createUnlimitedSource(f, u)
		if (!createdAsset.ok) return issues("Failed to create asset source")

		const imageAssetId = createdImageAsset.value.ID
		const id = createdAsset.value.ID

		await db.query(createAssetQuery, {
			assetType: typeToNumber[assetType],
			description,
			id,
			imageAssetId,
			name,
			price,
			visibility: user.permissionLevel < 3 ? "Pending" : "Visible",
		})

		await graphicAsset(assetType, imageAssetId, id)

		try {
			await Promise.all([saveImages[0](imageAssetId), saveImages[1](id)])
		} catch (e) {
			console.error("Rendering images failed!")
			console.error(e)
		}

		redirect(302, `/catalog/${id}/${encode(name)}`)
	}
)
