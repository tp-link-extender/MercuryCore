import { error, redirect } from "@sveltejs/kit"
import { assetNameOf } from "#lib/server/db/catalog.ts"
import { encode } from "#lib/urlName.ts"
import type { PageServerLoadEvent } from "./$types"

export async function load({ params }: PageServerLoadEvent) {
	const { id } = params
	const asset = await assetNameOf(Number(id))
	if (!asset) error(404, "Not Found")

	const slug = encode(asset.name)
	redirect(302, `/catalog/${id}/${slug}`)
}
