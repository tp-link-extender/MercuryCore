import { Record, equery, surql } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"

export async function load({ params }) {
	const id = +params.id
	const [[asset]] = await equery<{ name: string }[][]>(surql`
		SELECT name FROM ${Record("asset", id)}`)
	if (!asset) error(404, "Not found")

	redirect(302, `/catalog/${id}/${asset.name}`)
}
