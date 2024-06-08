import { RecordId, equery, surql } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"

type Asset = {
	id: number
	name: string
}

export async function load({ params }) {
	const [[asset]] = await equery<Asset[][]>(
		surql`SELECT name, meta::id(id) AS id FROM ${new RecordId(
			"asset",
			params.id
		)}`
	)
	if (!asset) error(404, "Not found")

	redirect(302, `/avatarshop/${params.id}/${asset.name}`)
}
