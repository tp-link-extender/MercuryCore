import { Record, db } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"
import assetQuery from "./asset.surql"

export async function load({ params }) {
	const { id } = params
	const [[asset]] = await db.query<{ name: string }[][]>(assetQuery, {
		asset: Record("asset", id),
	})
	if (!asset) error(404, "Not Found")

	redirect(302, `/catalog/${id}/${asset.name}`)
}
