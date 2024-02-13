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

/**
 * Requests a render from RCCService
 * todo write this
 */
export default async function (
	renderType: "Clothing" | "Avatar",
	relativeId: number,
	wait = false
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
		}
	)
	const render = renders[2]

	if (render && render.status !== "Error") return

	// If the render doesn't exist or if the last one errored, create a new render

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
		}
	)
	const renderId = newRender[1]
	// Tap in rcc

	const script = fs
		.readFileSync(`corescripts/processed/render${renderType}.lua`, "utf-8")
		.replaceAll("_BASE_URL", `"${process.env.RCC_ORIGIN}"`)
		.replaceAll("_THUMBNAIL_KEY", `"${process.env.RCC_KEY}"`)
		.replaceAll("_RENDER_TYPE", `"${renderType}"`)
		.replaceAll("_ASSET_ID", relativeId.toString())

	// Send the script to the RCCService proxy

	const path = `data/${
		renderType === "Avatar" ? "avatars" : "thumbnails"
	}/${relativeId}${renderType === "Avatar" ? ".png" : ""}`

	// If the file doesn't exist, wait for it to be created
	// if it does exist, wait for it to be modified
	const waiter =
		wait &&
		new Promise<void>(resolve => {
			try {
				const watcher = fs.watch(path, () => {
					watcher.close()
					resolve()
				})
			} catch {
				resolve()
			}
		})

	await Promise.all([
		waiter,
		// Uhh carrot just got the
		fetch(`${process.env.RCC_PROXY}/${renderId}`, {
			method: "POST",
			body: script,
		}),
	])
}
