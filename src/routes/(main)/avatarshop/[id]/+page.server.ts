import surql from "$lib/surrealtag"
import { query, squery } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"

export async function load({ params }) {
	if (!params.id || !/^\d+$/.test(params.id))
		throw error(400, `Invalid asset id: ${params.id}`)

	const asset = await squery<{
		id: number
		name: string
	}>(
		surql`
			SELECT
				name,
				meta::id(id) AS id
			FROM $asset`,
		{ asset: `asset:${params.id}` },
	)

	if (!asset) throw error(404, "Not found")

	throw redirect(302, `/avatarshop/${params.id}/${asset.name}`)
}
