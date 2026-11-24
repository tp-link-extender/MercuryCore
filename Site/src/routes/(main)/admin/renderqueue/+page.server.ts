import { authorise } from "#lib/server/auth.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import type { RenderType, Status } from "#lib/server/requestRender.ts"
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
		dbQuery<string[]>("stuff:ping.render"),
		dbQuery<Render[][]>(renderQueueQuery),
	])

	return { queue, status }
}
