import { mquery, surql } from "./surreal"
import fs from "fs"
import "dotenv/config"

type Render = {
	status: "Pending" | "Rendering" | "Completed" | "Error"
}

const selectRender = surql`
	(SELECT status, created, id
	FROM render WHERE status ∈ ["Pending", "Rendering"]
		AND type = $renderType
		AND relativeId = $relativeId)[0]`

export default async function (
	renderType: "Clothing" | "Avatar",
	relativeId: number,
) {
	const renders = await mquery<Render[]>(
		surql`
			LET $render = ${selectRender};
			IF $render AND $render.created + 1s < time::now() {
				UPDATE $render.id SET status = "Error"
			};
			RETURN ${selectRender}`,
		{
			renderType,
			relativeId,
		},
	)
	const render = renders[2]

	if (render && render.status != "Error") return

	// If the render doesn't exist or if the last one
	// errored, create a new render

	const newRender = await mquery<string[]>(
		surql`
			LET $render = (CREATE render CONTENT {
				type: $renderType,
				status: "Pending",
				created: time::now(),
				completed: NONE,
				relativeId: $relativeId
			})[0];
			RETURN meta::id($render.id)`,
		{
			renderType,
			relativeId,
		},
	)
	const renderId = newRender[1]

	console.log({ renderId })
	// Tap in rcc

	const script = fs
		.readFileSync(`corescripts/processed/render${renderType}.lua`, "utf-8")
		.replaceAll("_BASE_URL", `"${process.env.RCC_ORIGIN}"` as string)
		.replaceAll("_THUMBNAIL_KEY", `"${process.env.RCC_KEY}"` as string)
		.replaceAll("_RENDER_TYPE", `"${renderType}"`)
		.replaceAll("_ASSET_ID", relativeId.toString())

	const xml = fs
		.readFileSync(`xml/soap.xml`, "utf-8")
		.replaceAll("_TASK_ID", renderId)
		.replaceAll("_RENDER_SCRIPT", script)

	// Send the XML to RCCService

	await fetch("http://localhost:64989", {
		method: "POST",
		body: xml,
		headers: {
			"Content-Type": "text/xml; charset=utf-8",
			SOAPAction: "http://roblox.com/OpenJobEx",
		},
	})
}
