import { authorise } from "$lib/server/auth"
import type { RenderType, Status } from "$lib/server/requestRender"
import { db } from "$lib/server/surreal"
import type { PageServerLoadEvent } from "./$types"
import renderQueueQuery from "./renderqueue.surql"

interface Render {
	asset?: {
		id: number
		name: string
	}
	completed: string | null
	created: string
	id: number
	relativeId: number
	status: Status
	type: RenderType
	user?: BasicUser
}

export async function load({ locals }: PageServerLoadEvent) {
	await authorise(locals, 3)

	const [[status], [queue]] = await Promise.all([
		db.query<string[]>("stuff:ping.render"),
		db.query<Render[][]>(renderQueueQuery),
	])

	return { queue, status }
}
