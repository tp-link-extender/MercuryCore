import { query, squery, surql } from "$lib/server/surreal"
import { authorise } from "$lib/server/lucia"
import type { RenderType, Status } from "$lib/server/requestRender"

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

	return {
		status: await squery<string>(surql`[stuff:ping.render]`),
		queue: await query<Render>(import("./renderqueue.surql")),
	}
}
