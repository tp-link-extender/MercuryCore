import { prisma } from "$lib/server/prisma"
import { error, redirect } from "@sveltejs/kit"
import fs from "fs"

export async function GET({ params }) {
	if (!/^\d+$/.test(params.id))
		throw error(400, `Invalid asset id: ${params.id}`)

	const id = parseInt(params.id)

	if (
		!(await prisma.asset.findUnique({
			where: {
				id,
			},
		}))
	)
		throw error(404, "Not found")

	let file

	const files = [`data/thumbnails/${id}.png`, `data/assets/${id}`]

	for (const f of files)
		try {
			file = fs.readFileSync(f)
			break
		} catch (e) {}

	if (file) return new Response(file)
	else throw redirect(302, `/m....png`)
}
