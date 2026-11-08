import fs from "node:fs"
import config from "$lib/server/config"
import { db, Record } from "$lib/server/surreal"
import createRenderQuery from "./createRender.surql"
import renderQuery from "./render.surql"

export type RenderType =
	| "Clothing"
	| "Avatar"
	| "Model"
	| "Mesh"
	| "Package"
	| "Torso"
	| "LeftArm"
	| "RightArm"
	| "LeftLeg"
	| "RightLeg"
export type Status = "Pending" | "Rendering" | "Completed" | "Error"

interface Render {
	status: Status
}

/**
 * Requests a render from RCCService
 * @param renderType The type of render to request: "Clothing", "Avatar", "Model", "Mesh", "Package", "Torso", "LeftArm", "RightArm", "LeftLeg", or "RightLeg".
 * @param relativeId If "Avatar", the id of the user to render their avatar, otherwise the id of the asset to render.
 * @param relativeName If "Avatar", the name of the user to render their avatar.
 * @param wait Whether to wait for the render to be completed before resolving.
 */
export default async function requestRender(
	f: typeof globalThis.fetch,
	renderType: RenderType,
	relativeId: string | number,
	relativeName = relativeId,
	wait = false
) {
	// console.log(
	// 	`Requesting render of type ${renderType} for ${relativeId} (${relativeName})`
	// )

	const params = Object.freeze({ relativeId, renderType })
	// oxlint-disable-next-line unicorn/no-unreadable-array-destructuring -- query returns [result, error, value]
	const [, , render] = await db.query<Render[]>(renderQuery, params)
	if (render && render.status !== "Error") return

	// Check the script exists before creating a render record, otherwise a
	// pending render would be created that blocks all future retries
	const scriptFile = Bun.file(`../data/server/render/render${renderType}.lua`)
	if (!(await scriptFile.exists()))
		throw new Error(`Script file for ${renderType} does not exist`)

	const scriptText = await scriptFile.text()
	const [, renderId] = await db.query<string[]>(createRenderQuery, params)

	// console.log(`Created new render with ID ${renderId}`)

	// Tap in rcc
	const path =
		renderType === "Avatar" ? "../data/avatars" : "../data/thumbnails"
	if (!fs.existsSync(path)) fs.mkdirSync(path)

	// If the file doesn't exist, wait for it to be created
	// if it does exist, wait for it to be modified
	const waiter =
		wait &&
		// Wrapping the watcher callback in a promise is the simplest way to await it
		// oxlint-disable-next-line promise/avoid-new
		new Promise<void>(resolve => {
			// console.log(`Waiting for render file at ${path}`)
			try {
				const watcher = fs.watch(path, (_, filename) => {
					if (!filename?.startsWith(relativeId.toString())) 
						// console.log(`Ignoring change to ${filename}`)
						return
					
					watcher.close()
					// console.log("Watcher detected change!")
					resolve()
				})
				// console.log("Watcher started")
			} catch {
				// console.log("Watcher failed!", e)
				resolve()
			}
		})

	// Send the script to the RCCService proxy
	const pingUrl = `http://localhost:64990/ping/${renderId}` // the proxy will handle sending to /api/render/update

	const script = scriptText
		.replaceAll("_BASE_URL", `"${config.Domain}"`)
		.replaceAll("_RENDER_TYPE", `"${renderType}"`)
		.replaceAll("_ASSET_ID", `"${relativeName}"`) // TODO: make not string
		.replaceAll("_PING_URL", `"${pingUrl}"`)

	// console.log(
	// 	`Sending render request to RCCService for render ID ${renderId}`
	// )
	try {
		await Promise.all([
			waiter,
			// Uhh carrot just got the
			f(`${config.RCCServiceProxyURL}/${renderId}`, {
				body: script,
				method: "post",
			}),
		])
	} catch (e) {
		// Mark the render as errored so that a retry can try again, rather
		// than early-returning forever
		await db.update(Record("render", renderId)).merge({ status: "Error" })
		throw e
	}
}
