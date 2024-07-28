import { Record, equery, surql } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"

type Asset = {
	id: number
	name: string
}

export async function load({ params }) {
	const id = +params.id
	const [[asset]] = await equery<Asset[][]>(surql`
		SELECT name, meta::id(id) AS id FROM ${Record("asset", id)}`)
	if (!asset) error(404, "Not found")

	redirect(302, `/avatarshop/${id}/${asset.name}`)
}
