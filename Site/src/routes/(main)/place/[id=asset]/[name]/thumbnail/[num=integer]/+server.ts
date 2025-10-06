import { error } from "@sveltejs/kit"
import config from "$lib/server/config"
import { find } from "$lib/server/surreal"

const thumbnails = config.Images.DefaultPlaceThumbnails

export async function GET({ params }) {
	const id = +params.id
	if (!(await find("place", id))) error(404, "Not Found")

	const num = +params.num
	if (num < 0 || num >= thumbnails.length) error(404, "Not Found")

	return new Response(Bun.file(`../Assets/${thumbnails[num]}`))
}
