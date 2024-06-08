import { authorise } from "$lib/server/lucia"
import { intTest } from "$lib/server/paramTests"
import { RecordId, equery, surrealql } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"

type Asset = {
	id: number
	name: string
	visibility: string
}

export async function GET({ locals, params }) {
	if (!intTest(params.id)) error(400, `Invalid asset id: ${params.id}`)

	const id = +params.id

	const [[asset]] = await equery<Asset[][]>(
		surrealql`
			SELECT
				meta::id(id) AS id,
				name,
				visibility
			FROM ${new RecordId("asset", id)}`
	)

	if (!asset) error(404, "Not found")

	const { user } = await authorise(locals)
	if (asset.visibility === "Moderated")
		// If the asset is moderated
		redirect(302, "/mercurx.svg")
	if (asset.visibility !== "Visible" && user.permissionLevel < 4)
		// If the asset is pending review
		redirect(302, "/light/mQuestion.svg")

	let file: ArrayBuffer | undefined

	for (const f of [`data/thumbnails/${id}`, `data/assets/${id}`])
		try {
			file = await Bun.file(f).arrayBuffer()
			break
		} catch (e) {}

	if (file) return new Response(Buffer.from(file))
	// If the asset is visible, but the file doesn't exist (waiting for RCC?)
	redirect(302, "/m....png")
}
