import { authorise } from "$lib/server/lucia"
import { squery, surql } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"
import fs from "fs"

export async function GET({ locals, params }) {
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
		{ asset: `asset:${id}` },
	)

	if (!asset) throw error(404, "Not found")

	const { user } = await authorise(locals)
	if (asset.visibility == "Moderated")
		// If the asset is moderated
		throw redirect(302, `/mercurx.svg`)
	if (asset.visibility != "Visible" && user.permissionLevel < 4)
		// If the asset is pending review
		throw redirect(302, `/light/mQuestion.svg`)

	let file

	for (const f of [`data/thumbnails/${id}`, `data/assets/${id}`])
		try {
			file = fs.readFileSync(f)
			break
		} catch (e) {}

	if (file) return new Response(file)
	// If the asset is visible, but the file doesn't exist (waiting for RCC?)
	throw redirect(302, `/m....png`)
}
