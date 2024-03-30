import { query, squery, surql } from "$lib/server/surreal"
import { authorise } from "$lib/server/lucia"

type Render = {
	id: number
	type: "Clothing" | "Avatar"
	status: "Pending" | "Rendering" | "Completed" | "Error"
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
		queue: await query<Render>(surql`
			SELECT
				meta::id(id) AS id,
				type,
				status,
				created,
				completed,
				relativeId,
				IF $parent.type = "Avatar" THEN
					SELECT number, status, username
					FROM user WHERE number = $parent.relativeId
				END[0] AS user,
				IF $parent.type = "Clothing" THEN
					SELECT
						meta::id(id) AS id,
						name
					FROM asset WHERE id = $parent.relativeId
				END[0] AS asset
			FROM render ORDER BY created DESC`),
	}
}
