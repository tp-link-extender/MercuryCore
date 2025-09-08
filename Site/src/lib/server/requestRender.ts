import fs from "node:fs"
import { RCC_KEY } from "$env/static/private"
import config from "$lib/server/config"
import { db } from "$lib/server/surreal"
import createRenderQuery from "./createRender.surql"
import renderQuery from "./render.surql"

export type RenderType = "Clothing" | "Avatar" | "Model" | "Mesh"
export type Status = "Pending" | "Rendering" | "Completed" | "Error"

type Render = {
	status: Status
}

/**
 * Requests a render from RCCService
 * @param renderType The type of render to request, "Clothing", "Avatar", "Model", or "Mesh".
 * @param relativeId If "Avatar", the id of the user to render their avatar, otherwise the id of the asset to render.
 * @param relativeName If "Avatar", the name of the user to render their avatar.
 * @param wait Whether to wait for the render to be completed before resolving.
 */
export default async function (
	renderType: RenderType,
	relativeId: string,
	relativeName = relativeId,
	wait = false
) {
	const params = { renderType, relativeId }
	const [, , render] = await db.query<Render[]>(renderQuery, params)
	if (render && render.status !== "Error") return

	// If the render doesn't exist or if the last one errored, create a new render
	const [, renderId] = await db.query<string[]>(createRenderQuery, params)

	// Tap in rcc
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
	const scriptFile = Bun.file(`../data/server/render/render${renderType}.lua`)
	if (!(await scriptFile.exists()))
		throw new Error(`Script file for ${renderType} does not exist`)

	const pingUrl = `${config.RCCServiceProxyURL}/ping/${renderId}` // the proxy will handle sending to /api/render/update

	const script = (await scriptFile.text())
		.replaceAll("_BASE_URL", `"${config.Domain}"`)
		.replaceAll("_THUMBNAIL_KEY", `"${RCC_KEY}"`)
		.replaceAll("_RENDER_TYPE", `"${renderType}"`)
		.replaceAll("_ASSET_ID", `"${relativeName}"`)
		.replaceAll("_PING_URL", `"${pingUrl}"`)

	await Promise.all([
		waiter,
		// Uhh carrot just got the
		fetch(`${config.RCCServiceProxyURL}/${renderId}`, {
			method: "POST",
			body: script,
		}),
	])
}
