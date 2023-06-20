import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
// import ratelimit from "$lib/server/ratelimit"
import formError from "$lib/server/formError"
import {
	imageAsset,
	tShirt,
	tShirtThumbnail,
	thumbnail,
} from "$lib/server/imageAsset"
import { graphicAsset } from "$lib/server/xmlAsset"
import fs from "fs"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	type: z.enum(["2", "11", "12", "13"]),
	name: z.string().min(3).max(50),
	description: z.string().min(1).max(1000),
	price: z.number().int().min(0).max(999),
	asset: z.any(),
})

const assets: any = {
	2: "T-Shirt",
	11: "Shirt",
	12: "Pants",
	13: "Decal",
}

export const load = async ({ request, locals }) => {
	await authorise(locals, 5)

	return {
		form: superValidate(schema),
		assettype: new URL(request.url).searchParams.get("asset"),
	}
}

export const actions = {
	default: async ({ request, locals, getClientAddress }) => {
		const { user } = await authorise(locals)

		const formData = await request.formData()
		const form = await superValidate(formData, schema)
		if (!form.valid) return formError(form)

		// const limit = ratelimit(form, "assetCreation", getClientAddress, 30)
		// if (limit) return limit

		const { type, name, description, price } = form.data
		const assetType = parseInt(type)

		const asset = formData.get("asset") as File

		if (!asset)
			return formError(form, ["asset"], ["You must upload an asset"])

		if (asset.size > 20e6)
			return formError(
				form,
				["asset"],
				["Asset must be less than 20MB in size"]
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
						["Asset failed to upload"]
					)
				}
				break

			case 11: // Shirt
				return formError(
					form,
					["type"],
					["Cannot upload this type of asset yet"]
				)

			case 12: // Pants
				return formError(
					form,
					["type"],
					["Cannot upload this type of asset yet"]
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
						["Asset failed to upload"]
					)
				}
		}

		const { id, imageAssetId }: { id: number; imageAssetId: any } =
			await prisma.asset.create({
				data: {
					creatorUser: {
						// cannot be creatorUsername
						connect: {
							id: user.id,
						},
					},
					owners: {
						connect: {
							id: user.id,
						},
					},
					name,
					description: {
						create: {
							text: description,
						},
					},
					type: assetType,
					imageAsset: {
						create: {
							creatorUser: {
								// cannot be creatorUsername
								connect: {
									id: user.id,
								},
							},
							owners: {
								connect: {
									id: user.id,
								},
							},
							name,
							type: 1,
							price: 0,
						},
					},
					price,
				},
			})

		for (const save of saveImages) save(imageAssetId)
		graphicAsset(assets[assetType], imageAssetId, id)
	},
}
