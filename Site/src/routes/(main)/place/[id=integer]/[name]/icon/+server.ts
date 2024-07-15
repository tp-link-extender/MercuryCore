import { find } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"

export async function GET({ params }) {
	const id = +params.id
	const filename = `data/icons/${id}.webp`

	if (!(await find("place", id))) error(404, "Not found")

	if (!(await Bun.file(filename).exists()))
		redirect(302, "/place/placeholderIcon.webp")

	return new Response(Bun.file(filename))
}
