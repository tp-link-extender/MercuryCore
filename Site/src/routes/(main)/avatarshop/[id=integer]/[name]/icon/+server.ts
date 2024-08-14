import { authorise } from "$lib/server/lucia"
import { Record, equery, surql } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"

type Asset = {
	name: string
	visibility: string
}

const dirs = Object.freeze(["thumbnails", "assets"]) // simpler-ish

export async function GET({ locals, params }) {
	const { user } = await authorise(locals)
	const id = +params.id
	const [[asset]] = await equery<Asset[][]>(
		surql`SELECT name, visibility FROM ${Record("asset", id)}`
	)
	if (!asset) error(404, "Not found")

	if (asset.visibility === "Moderated") redirect(302, "/mercurx.svg")
	// If the asset is pending review
	if (asset.visibility !== "Visible" && user.permissionLevel < 4)
		redirect(302, "/error/mQuestion.svg")

	for (const f of dirs.map(d => `../data/${d}/${id}`))
		try {
			const file = await Bun.file(f).arrayBuffer()
			if (file) return new Response(Buffer.from(file))
		} catch (e) {}

	// If the asset is visible, but the file doesn't exist (waiting for RCC?)
	redirect(302, "/dots.png")
}
