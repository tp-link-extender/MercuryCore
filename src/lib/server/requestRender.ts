import surql from "../surrealtag"
import { query } from "./surreal"
import "dotenv/config"

type Render = {
	id: number
	type: "Asset" | "Avatar"
	status: "Pending" | "Rendering" | "Completed"
	created: string
	completed: string | null
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

export default async function (
	renderType: "Asset" | "Avatar",
	relativeId: number,
) {
	const renders = await query<Render>(
		surql`
			LET $render = SELECT
				meta::id(id) AS id,
				type,
				status,
				created,
				completed,
				IF $parent.type = "user" THEN
					SELECT
						number,
						status,
						username
					FROM user WHERE number = $parent.relativeId
				END AS user,
				IF $parent.type = "asset" THEN
					SELECT
						meta::id(id) AS id,
						name
					FROM asset WHERE id = $parent.relativeId
				END AS asset
			FROM renders
			WHERE status ∈ ["Pending", "Rendering"]
				AND renderType = $renderType
				AND relativeId = $assetId;
			IF created + 1m < time::now() {
				UPDATE $render SET status = "Error"
			}
			RETURN $render`,
		{
			renderType,
			relativeId,
		},
	)
	const render = renders[2]

	if (!render) return

	console.log(render)
}
