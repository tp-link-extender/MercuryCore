import surql from "$lib/surrealtag"
import { query } from "$lib/server/surreal"

type Render = {
	id: number
	type: "Clothing" | "Avatar"
	status: "Pending" | "Rendering" | "Completed" | "Error"
	created: string
	completed: string | null
	relativeId: number
	user?: {
		number: number
		status: "Playing" | "Online" | "Offline"
		username: string
	}
	asset?: {
		id: number
		name: string
	}
}

export const load = () => ({
	status: query(surql`stuff:ping.render`) as unknown as string,
	queue: query<Render>(surql`
		SELECT
			meta::id(id) AS id,
			type,
			status,
			created,
			completed,
			relativeId,
			IF $parent.type = "Avatar" THEN
				SELECT
					number,
					status,
					username
				FROM user WHERE number = $parent.relativeId
			END[0] AS user,
			IF $parent.type = "Clothing" THEN
				SELECT
					meta::id(id) AS id,
					name
				FROM asset WHERE id = $parent.relativeId
			END[0] AS asset
		FROM render ORDER BY created DESC`),
})
