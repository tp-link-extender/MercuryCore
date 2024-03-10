import { place } from "$lib/server/orm"
import { error, redirect } from "@sveltejs/kit"
import fs from "fs"

export async function GET({ params }) {
	if (!/^\d+$/.test(params.id)) error(400, `Invalid game id: ${params.id}`)

	const id = parseInt(params.id)
	const filename = `data/icons/${id}.webp`

	if (!(await place.find(id.toString()))) error(404, "Not found")

	if (!fs.existsSync(filename))
		redirect(302, `/place/placeholderIcon${1 + (id % 3)}.webp`)

	return new Response(fs.readFileSync(filename))
}
