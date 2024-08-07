import { authorise } from "$lib/server/lucia"
import { Record, equery, surql } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"

type Asset = {
	id: number
	name: string
	visibility: string
}

const dirs = Object.freeze(["thumbnails", "assets"]) // simpler-ish

export async function GET({ locals, params }) {
	const id = +params.id
	const [[asset]] = await equery<Asset[][]>(
		surql`
			SELECT meta::id(id) AS id, name, visibility
			FROM ${Record("asset", id)}`
	)

	if (!asset) error(404, "Not found")

	const { user } = await authorise(locals)
	if (asset.visibility === "Moderated")
		// If the asset is moderated
		redirect(302, "/mercurx.svg")
	if (asset.visibility !== "Visible" && user.permissionLevel < 4)
		// If the asset is pending review
		redirect(302, "/error/mQuestion.svg")

	for (const f of dirs.map(d => `../data/${d}/${id}`))
		try {
			const file = await Bun.file(f).arrayBuffer()
			if (file) return new Response(Buffer.from(file))
		} catch (e) {}

	// If the asset is visible, but the file doesn't exist (waiting for RCC?)
	redirect(302, "/dots.png")
}
