import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { authorise } from "$lib/server/auth"
import formError from "$lib/server/formError"
import { db, Record } from "$lib/server/surreal"
import { arktype, message, superValidate } from "$lib/server/validate"
import { encode } from "$lib/urlName"
import assetQuery from "./asset.surql"
import assetCheckQuery from "./assetCheck.surql"
import updateAssetQuery from "./updateAsset.surql"

type Asset = {
	id: string
	created: Date
	creator: BasicUser
	description: {
		text: string
		updated: Date
	}
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

export async function load({ locals, params }) {
	const { user } = await authorise(locals)
	const id = +params.id
	const [[asset]] = await db.query<Asset[][]>(assetQuery, {
		asset: Record("asset", id),
		user: Record("user", user.id),
	})
	if (!asset) error(404, "Not Found")

	console.log(asset)

	return {
		...asset,
		slug: encode(asset.name),
		form: await superValidate(
			{
				name: asset.name,
				forSale: asset.forSale,
				description: asset.description.text,
				price: asset.price,
			},
			arktype(schema)
		),
	}
}

export const actions: import("./$types").Actions = {}

type AssetCheck = {
	id: string
	created: Date
	isCreator: boolean
	description: {
		text: string
		updated: Date
	}
	forSale: boolean
	name: string
	price: number
	type: number
	visibility: string
}

actions.default = async ({ locals, params, request }) => {
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
