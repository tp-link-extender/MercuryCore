import { find } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"

export async function GET({ params }) {
	const id = +params.id
	if (!(await find("place", id))) error(404, "Not found")

	const file = Bun.file(`../data/icons/${id}.avif`)
	if (await file.exists()) return new Response(file)

	redirect(302, "/place/placeholderIcon.avif")
}
