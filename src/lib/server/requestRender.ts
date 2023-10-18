import surql from "../surrealtag"
import { mquery } from "./surreal"
import fs from "fs"
import "dotenv/config"

type Render = {
	id: number
	type: "Clothing" | "Avatar"
	status: "Pending" | "Rendering" | "Completed" | "Error"
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
	renderType: "Clothing" | "Avatar",
	relativeId: number,
) {
	const renders = await mquery<Render[][]>(
		surql`
			LET $render = SELECT
				meta::id(id) AS id,
				type,
				status,
				created,
				completed,
				relativeId,
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
			FROM render
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
	const render = renders[2][0]

	if (render && render.status != "Error") return

	// If the render doesn't exist or if the last one
	// errored, create a new render

	const newRender = await mquery<{ id: string }[]>(
		surql`
			LET $render = CREATE render CONTENT {
				type: $renderType,
				status: "Pending",
				created: time::now(),
				completed: NONE,
				relativeId: $relativeId
			};
			RETURN meta::id($render)`,
		{
			renderType,
			relativeId,
		},
	)
	const renderId = newRender[1].id

	// Tap in rcc

	const xml = fs
		.readFileSync(`xml/soap.xml`, "utf-8")
		.replaceAll("_TASK_ID", renderId)
		.replaceAll(
			"_RENDER_SCRIPT",
			fs.readFileSync(
				`corescripts/processed/render${renderType}.lua`,
				"utf-8",
			),
		)
		.replaceAll("_BASE_URL", process.env.RCC_ORIGIN as string)
		.replaceAll("_THUMBNAIL_KEY", process.env.RCC_KEY as string)
		.replaceAll("_RENDER_TYPE", renderType)
		.replaceAll("_ASSET_ID", relativeId.toString())

	// Send the XML to RCCService

	console.log(render)
}
