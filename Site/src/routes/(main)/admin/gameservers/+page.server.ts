import { error } from "@sveltejs/kit"
import { authorise } from "$lib/server/auth"
import { listGameservers } from "$lib/server/orbiter"
import type { PageServerLoadEvent } from "./$types"

export async function load({ fetch: f, locals }: PageServerLoadEvent) {
	await authorise(locals, 5)

	const gameservers = await listGameservers(f)
	if (!gameservers.ok) error(500, "Failed to fetch gameservers")

	return {
		gameservers: gameservers.value,
	}
}
