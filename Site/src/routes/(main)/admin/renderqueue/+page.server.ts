import { authorise } from "$lib/server/auth"
import type { RenderType, Status } from "$lib/server/requestRender"
import { db } from "$lib/server/surreal"
import renderQueueQuery from "./renderqueue.surql"

type Render = {
	id: number
	type: RenderType
	status: Status
	created: string
	completed: string | null
	relativeId: number
	user?: BasicUser
	asset?: {
		id: number
		name: string
	}
}

export async function load({ locals }) {
	await authorise(locals, 3)

	const [[status], [queue]] = await Promise.all([
		db.query<string[]>("stuff:ping.render"),
		db.query<Render[][]>(renderQueueQuery),
	])

	return { status, queue }
}
