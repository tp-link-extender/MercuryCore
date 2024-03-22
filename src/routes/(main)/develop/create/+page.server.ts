import { authorise } from "$lib/server/lucia"
import { mquery, surql } from "$lib/server/surreal"
import ratelimit from "$lib/server/ratelimit"
import formError from "$lib/server/formError"
import {
	clothingAsset,
	imageAsset,
	tShirt,
	tShirtThumbnail,
	thumbnail,
} from "$lib/server/imageAsset"
import { graphicAsset } from "$lib/server/xmlAsset"
import { redirect } from "@sveltejs/kit"
import fs from "node:fs"
import { superValidate } from "sveltekit-superforms/server"
import { zod } from "sveltekit-superforms/adapters"
import { z } from "zod"
import requestRender from "$lib/server/requestRender"

const schema = z.object({
	// Object.keys(assets) doesn't work
	type: z.enum(["2", "8", "11", "12", "13", "18"]),
	name: z.string().min(3).max(50),
	description: z.string().max(1000).optional(),
	price: z.number().int().min(0).max(999),
	asset: z.any(),
})
const assets: { [k: number]: string } = {
	2: "T-Shirt",
	11: "Shirt",
	12: "Pants",
	13: "Decal",
}

export async function load({ request, locals }) {
	await authorise(locals, 5)

	return {
		form: await superValidate(zod(schema)),
		assettype: new URL(request.url).searchParams.get("asset"),
	}
}

export const actions = {
	default: async ({ request, locals, getClientAddress }) => {
		const { user } = await authorise(locals)
		const formData = await request.formData()
		const form = await superValidate(formData, zod(schema))
		if (!form.valid) return formError(form)

		const { type, name, description, price } = form.data
		const assetType = +type as keyof typeof assets
		const asset = formData.get("asset") as File

		if (!asset || asset.size < 1)
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

		let saveImages: ((id: number) => void | Promise<void>)[] = []

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
					saveImages[1] = (id: number) =>
						requestRender("Clothing", id)

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
			}
		} catch (e) {
			console.log(e)
			return formError(form, ["asset"], ["Asset failed to upload"])
		}

		const res = await mquery<number[]>(
			surql`
				LET $id = (UPDATE ONLY stuff:increment SET asset += 1).asset;
				LET $imageAsset = CREATE asset CONTENT {
					id: $id,
					name: $name,
					type: 1,
					price: 0,
					description: [],
					created: time::now(),
					updated: time::now(),
					visibility: "Pending",
				};
				RELATE $user->owns->$imageAsset;
				RELATE $user->created->$imageAsset;

				LET $id2 = (UPDATE ONLY stuff:increment SET asset += 1).asset;
				LET $asset = CREATE asset CONTENT {
					id: $id2,
					name: $name,
					type: $assetType,
					price: $price,
					description: [{
						text: $description,
						updated: time::now(),
					}],
					created: time::now(),
					updated: time::now(),
					visibility: "Pending",
				};
				RELATE $user->owns->$asset;
				RELATE $user->created->$asset;
				RELATE $asset->imageAsset->$imageAsset;
				$id; # return the idz
				$id2`,
			{
				name,
				assetType,
				price,
				description,
				user: `user:${user.id}`,
			}
		)

		const imageAssetId = res[9]
		const id = res[10] // concurrency issues fixed hopefully

		graphicAsset(assets[assetType], imageAssetId, id)

		try {
			await saveImages[0](imageAssetId)
			await saveImages[1](id)
		} catch (e) {
			console.log("Rendering images failed!")
			console.error(e)
		}

		redirect(302, `/avatarshop/${id}/${name}`)
	},
}
