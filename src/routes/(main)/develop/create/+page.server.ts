import surql from "$lib/surrealtag"
import { authorise } from "$lib/server/lucia"
import { query, squery } from "$lib/server/surreal"
import ratelimit from "$lib/server/ratelimit"
import formError from "$lib/server/formError"
import {
	imageAsset,
	tShirt,
	tShirtThumbnail,
	thumbnail,
} from "$lib/server/imageAsset"
import { graphicAsset } from "$lib/server/xmlAsset"
import { redirect } from "@sveltejs/kit"
import fs from "fs"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
		type: z.enum(["2", "11", "12", "13"]),
		name: z.string().min(3).max(50),
		description: z.string().max(1000).optional(),
		price: z.number().int().min(0).max(999),
		asset: z.any(),
	}),
	assets: { [k: number]: any } = {
		2: "T-Shirt",
		11: "Shirt",
		12: "Pants",
		13: "Decal",
	}

export async function load({ request, locals }) {
	await authorise(locals, 5)

	return {
		form: superValidate(schema),
		assettype: new URL(request.url).searchParams.get("asset"),
	}
}

export const actions = {
	default: async ({ request, locals, getClientAddress }) => {
		const { user } = await authorise(locals),
			formData = await request.formData(),
			form = await superValidate(formData, schema)
		if (!form.valid) return formError(form)

		const limit = ratelimit(form, "assetCreation", getClientAddress, 30)
		if (limit) return limit

		const { type, name, description, price } = form.data,
			assetType = parseInt(type),
			asset = formData.get("asset") as File

		if (!asset)
			return formError(form, ["asset"], ["You must upload an asset"])

		if (asset.size > 20e6)
			return formError(
				form,
				["asset"],
				["Asset must be less than 20MB in size"],
			)

		if (!fs.existsSync("data/assets")) fs.mkdirSync("data/assets")
		if (!fs.existsSync("data/thumbnails")) fs.mkdirSync("data/thumbnails")

		let saveImages: ((arg0: string | number) => void)[] = []

		switch (assetType) {
			case 2: // T-Shirt
				try {
					saveImages = await Promise.all([
						tShirt(asset),
						tShirtThumbnail(asset),
					])
				} catch (e) {
					console.log(e)
					return formError(
						form,
						["asset"],
						["Asset failed to upload"],
					)
				}
				break

			case 11: // Shirt
				return formError(
					form,
					["type"],
					["Cannot upload this type of asset yet"],
				)

			case 12: // Pants
				return formError(
					form,
					["type"],
					["Cannot upload this type of asset yet"],
				)

			case 13: // Decal
				try {
					saveImages = await Promise.all([
						imageAsset(asset),
						thumbnail(asset),
					])
				} catch (e) {
					console.log(e)
					return formError(
						form,
						["asset"],
						["Asset failed to upload"],
					)
				}
		}

		const currentId = (await query(
				surql`stuff:increment.asset`,
			)) as unknown as number,
			imageAssetId = currentId + 1,
			id = currentId + 2

		await query(
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
				RELATE $asset->imageAsset->$imageAsset`,
			{
				name,
				assetType,
				price,
				description,
				user: `user:${user.id}`,
			},
		)

		saveImages[0](imageAssetId)
		saveImages[1](id)
		graphicAsset(assets[assetType], imageAssetId, id)

		throw redirect(302, `/avatarshop/${id}/${name}`)
	},
}
