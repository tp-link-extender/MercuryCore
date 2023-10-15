import surql from "$lib/surrealtag"
import { squery } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"
import fs from "fs"

export async function GET({ params }) {
	if (!/^\d+$/.test(params.id))
		throw error(400, `Invalid asset id: ${params.id}`)

	const id = parseInt(params.id)

	const asset = await squery<{
		id: number
		name: string
		visibility: string
	}>(
		surql`
			SELECT
				meta::id(id) AS id,
				name,
				visibility
			FROM $asset`,
		{ asset: `asset:${params.id}` },
	)

	if (!asset) throw error(404, "Not found")
	if (asset.visibility != "Public") throw redirect(302, `/m....png`)

	let file

	for (const f of [`data/thumbnails/${id}.png`, `data/assets/${id}`])
		try {
			file = fs.readFileSync(f)
			break
		} catch (e) {}

	if (file) return new Response(file)
	throw redirect(302, `/m....png`)
}
