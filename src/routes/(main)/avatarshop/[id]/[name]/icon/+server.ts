import surql from "$lib/surrealtag"
import { squery } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"
import fs from "fs"

export async function GET({ params }) {
	if (!/^\d+$/.test(params.id))
		throw error(400, `Invalid asset id: ${params.id}`)

	const id = parseInt(params.id)

	if (
		!(
			(await squery(
				surql`
					SELECT
						name, 
						meta::id(id) AS id
					FROM $asset`,
				{ asset: `asset:${params.id}` },
			)) as {
				id: number
				name: string
			}[]
		)[0]
	)
		throw error(404, "Not found")

	let file

	for (const f of [`data/thumbnails/${id}.png`, `data/assets/${id}`])
		try {
			file = fs.readFileSync(f)
			break
		} catch (e) {}

	if (file) return new Response(file)
	else throw redirect(302, `/m....png`)
}
