import { db } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"
import assetQuery from "./asset.surql"

export async function load({ params }) {
	const id = +params.id
	const [[asset]] = await db.query<{ name: string }[][]>(assetQuery)
	if (!asset) error(404, "Not found")

	redirect(302, `/catalog/${id}/${asset.name}`)
}
