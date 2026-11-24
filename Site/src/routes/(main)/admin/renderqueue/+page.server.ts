import { authorise } from "#lib/server/auth.ts"
import { lastRenderPing, renderQueueOf } from "#lib/server/db/renders.ts"
import type { PageServerLoadEvent } from "./$types"

export async function load({ locals }: PageServerLoadEvent) {
	await authorise(locals, 3)

	const [status, queue] = await Promise.all([
		lastRenderPing(),
		renderQueueOf(),
	])

	return { queue, status }
}
