import fs from "node:fs"
import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { form, getRequestEvent } from "$app/server"
import { typeToNumber } from "$lib/assetTypes"
import { authorise } from "$lib/server/auth"
import { createAsset } from "$lib/server/economy"
import { randomAssetId } from "$lib/server/id"
import {
	clothingAsset,
	imageAsset,
	thumbnail,
	tShirt,
	tShirtThumbnail,
} from "$lib/server/imageAsset"
import { ratelimitRemote } from "$lib/server/ratelimit"
import requestRender from "$lib/server/requestRender"
import { db, Record } from "$lib/server/surreal"
import { graphicAsset } from "$lib/server/xmlAsset"
import { encode } from "$lib/urlName"
import type { ClientForm } from "$lib/validate"
import assetTypes from "./assetTypes"
import createAssetQuery from "./createAsset.surql"

const schema = type({
	// Object.keys(assets) doesn't work
	type: type.enumerated(...assetTypes).configure({
		problem: "must be a valid asset type",
	}),
	name: "3 <= string <= 50",
	"description?": "1 <= string <= 1000",
	price: "number.integer <= 999",
	asset: "File",
})

export const formData: ClientForm<typeof schema.infer> = form(
	schema,
	async ({ type, name, description, price, asset }, issues) => {
		const { fetch: f, locals, getClientAddress } = getRequestEvent()
		const { user } = await authorise(locals)

		if (!asset || asset.size === 0)
			return issues.asset("You must upload an asset")
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

		const slug = encode(name)
		const imageAssetId = randomAssetId()
		const id = randomAssetId()

		if (user.permissionLevel < 3) {
			const created = await createAsset(f, user.id, id, name, slug)
			if (!created.ok) return issues(created.msg)
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
			console.error("Rendering images failed!")
			console.error(e)
		}

		redirect(302, `/catalog/${id}/${name}`)
	}
)
