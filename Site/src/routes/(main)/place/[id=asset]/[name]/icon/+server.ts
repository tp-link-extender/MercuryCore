import { error } from "@sveltejs/kit"
import config from "#lib/server/config.ts"
import { find } from "#lib/server/db/records.ts"
import type { RequestEvent } from "./$types"

const icons = config.Images.DefaultPlaceIcons

export async function GET({ params }: RequestEvent) {
	const id = Number(params.id)
	if (!(await find("place", id))) error(404, "Not Found")

	const file = Bun.file(`../data/icons/${id}.avif`)
	if (await file.exists()) return new Response(file)

	return new Response(Bun.file(`../Assets/${icons[id % icons.length]}`))
}
