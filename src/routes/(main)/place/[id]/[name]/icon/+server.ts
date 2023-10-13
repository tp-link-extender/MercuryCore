import surreal from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"
import fs from "fs"

export async function GET({ params }) {
	if (!/^\d+$/.test(params.id))
		throw error(400, `Invalid game id: ${params.id}`)

	const id = parseInt(params.id),
		filename = `data/icons/${id}.webp`

	if (!(await surreal.select(`place:${id}`))[0]) throw error(404, "Not found")

	if (!fs.existsSync(filename))
		throw redirect(302, `/place/placeholderIcon${1 + (id % 3)}.webp`)

	return new Response(fs.readFileSync(filename))
}
