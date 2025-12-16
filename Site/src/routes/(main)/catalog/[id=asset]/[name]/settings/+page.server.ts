import { error } from "@sveltejs/kit"
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
	name: string
	price: number
	type: number
	visibility: string
}

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
	}
}
