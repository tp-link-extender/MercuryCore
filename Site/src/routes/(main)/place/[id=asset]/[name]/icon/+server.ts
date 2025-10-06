import { error } from "@sveltejs/kit"
import config from "$lib/server/config"
import { find } from "$lib/server/surreal"

const icons = config.Images.DefaultPlaceIcons

export async function GET({ params }) {
	const id = +params.id
	if (!(await find("place", id))) error(404, "Not Found")

	const file = Bun.file(`../data/icons/${id}.avif`)
	if (await file.exists()) return new Response(file)

	return new Response(Bun.file(`../Assets/${icons[id % icons.length]}`))
}
