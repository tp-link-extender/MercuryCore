import fs from "node:fs"
import { equery, surql } from "./surreal.ts"

export type Status = "Pending" | "Rendering" | "Completed" | "Error"
export type RenderType = "Clothing" | "Avatar" | "Model" | "Mesh"

type Render = {
	status: Status
}

const selectRender = `
	(SELECT status, created, id
	FROM render WHERE status IN ["Pending", "Rendering"]
		AND type = $renderType
		AND relativeId = $relativeId)[0]`

/**
 * Requests a render from RCCService
 * @param renderType The type of render to request, "Clothing", "Avatar", "Model", or "Mesh".
 * @param relativeId If "Avatar", the number of the user to render their avatar, otherwise the id of the asset to render.
 * @param wait Whether to wait for the render to be completed before resolving.
 */
export default async function (
	renderType: RenderType,
	relativeId: string | number,
	wait = false
) {
	const [, , render] = await equery<Render[]>(
		`
			LET $render = ${selectRender};
			IF $render AND $render.created + 1s < time::now() {
				UPDATE $render.id SET status = "Error"
			};
			# need the updated one
			${selectRender}`,
		{ renderType, relativeId }
	)

	if (render && render.status !== "Error") return

	// If the render doesn't exist or if the last one errored, create a new render

	const [, renderId] = await equery<string[]>(
		surql`
			LET $render = (CREATE render CONTENT {
				type: $renderType,
				status: "Pending",
				created: time::now(),
				completed: NONE,
				relativeId: $relativeId
			})[0];
			meta::id($render.id)`,
		{ renderType, relativeId }
	)
	// Tap in rcc

	const scriptFile = Bun.file(`corescripts/processed/render${renderType}.lua`)
	const script = (await scriptFile.text())
		.replaceAll("_BASE_URL", `"${process.env.DOMAIN}"`)
		.replaceAll("_THUMBNAIL_KEY", `"${process.env.RCC_KEY}"`)
		.replaceAll("_RENDER_TYPE", `"${renderType}"`)
		.replaceAll("_ASSET_ID", relativeId.toString())

	// Send the script to the RCCService proxy

	const path =
		renderType === "Avatar"
			? `data/avatars/${relativeId}.png`
			: `data/thumbnails/${relativeId}`

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
