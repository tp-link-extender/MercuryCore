import fs from "node:fs"
import config from "$lib/server/config"
import { db } from "$lib/server/surreal"
import createRenderQuery from "./createRender.surql"
import renderQuery from "./render.surql"

export type Status = "Pending" | "Rendering" | "Completed" | "Error"
export type RenderType = "Clothing" | "Avatar" | "Model" | "Mesh"

type Render = {
	status: Status
}

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
	const params = { renderType, relativeId }
	const [, , render] = await db.query<Render[]>(renderQuery, params)
	if (render && render.status !== "Error") return

	// If the render doesn't exist or if the last one errored, create a new render
	const [, renderId] = await db.query<string[]>(createRenderQuery, params)

	// Tap in rcc
	const scriptFile = Bun.file(`../Corescripts/render${renderType}.lua`)
	const script = (await scriptFile.text())
		.replaceAll("_BASE_URL", config.Domain)
		.replaceAll("_THUMBNAIL_KEY", process.env.RCC_KEY)
		.replaceAll("_RENDER_TYPE", renderType)
		.replaceAll("_ASSET_ID", relativeId.toString())

	const path =
		renderType === "Avatar"
			? `../data/avatars/${relativeId}.png`
			: `../data/thumbnails/${relativeId}`

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

	// Send the script to the RCCService proxy
	await Promise.all([
		waiter,
		// Uhh carrot just got the
		fetch(`${config.RCCServiceProxyURL}/${renderId}`, {
			method: "POST",
			body: script,
		}),
	])
}
