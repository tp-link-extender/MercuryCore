import { error, redirect } from "@sveltejs/kit"
import { dbQuery } from "#lib/server/db/query.ts"
import { Record } from "#lib/server/surreal.ts"
import { encode } from "#lib/urlName.ts"
import type { PageServerLoadEvent } from "./$types"
import assetQuery from "./asset.surql"

export async function load({ params }: PageServerLoadEvent) {
	const { id } = params
	const [[asset]] = await dbQuery<{ name: string }[][]>(assetQuery, {
		asset: Record("asset", Number(id)),
	})
	if (!asset) error(404, "Not Found")

	const slug = encode(asset.name)
	redirect(302, `/catalog/${id}/${slug}`)
}
