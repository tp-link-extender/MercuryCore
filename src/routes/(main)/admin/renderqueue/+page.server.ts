import { surql, equery } from "$lib/server/surreal"
import { authorise } from "$lib/server/lucia"
import type { RenderType, Status } from "$lib/server/requestRender"
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

	const [[status]] = await equery<string[][]>(surql`[stuff:ping.render]`)
	const [queue] = await equery<Render[][]>(renderQueueQuery)

	return { status, queue }
}
