import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { superValidate } from "sveltekit-superforms/server"
import { authorise } from "$lib/server/auth"
import { db, Record } from "$lib/server/surreal"
import { encode } from "$lib/urlName"
import assetQuery from "./asset.surql"

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
	forSale: "boolean",
})

export async function load({ locals, params }) {
	const { user } = await authorise(locals)
	const id = +params.id
	const [[asset]] = await db.query<Asset[][]>(assetQuery, {
		asset: Record("asset", id),
		user: Record("user", user.id),
	})
	if (!asset || !asset.creator) error(404, "Not Found")

	return {
		...asset,
		slug: encode(asset.name),
		form: await superValidate(arktype(schema)),
	}
}

actions.default = async ({ locals, params, request }) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, arktype(schema))
	if (!form.valid) return formError(form)

	const id = +params.id
}
