import fs from "node:fs"
import config from "#lib/server/config.ts"
import {
	activeRenderStatus,
	createRender,
	failRender,
	type RenderType,
} from "#lib/server/db/renders.ts"
import { buildLoadscript } from "#lib/server/loadscript.ts"
import { waitForChange } from "#lib/server/waitForChange.ts"
import { renderFileMatcher } from "./renderFileMatch.ts"

export type { RenderType, Status } from "#lib/server/db/renders.ts"

// How long a caller waits for a render to finish
const renderTimeout = 60_000

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

	const status = await activeRenderStatus(relativeId, renderType)
	if (status && status !== "Error") return

	// Check the script exists before creating a render record, otherwise a
	// pending render would be created that blocks all future retries
	const scriptFile = Bun.file(`../data/server/render/render${renderType}.lua`)
	if (!(await scriptFile.exists()))
		throw new Error(`Script file for ${renderType} does not exist`)

	const scriptText = await scriptFile.text()
	const renderId = await createRender(relativeId, renderType)

	// console.log(`Created new render with ID ${renderId}`)

	// Tap in rcc
	const path =
		renderType === "Avatar" ? "../data/avatars" : "../data/thumbnails"
	if (!fs.existsSync(path)) fs.mkdirSync(path)

	// Wait for the render's file to be created or modified, but not forever
	const waiter =
		wait &&
		waitForChange(
			path,
			renderTimeout,
			renderFileMatcher(renderType, relativeId)
		)

	// Send the script to the RCCService proxy
	const pingUrl = `http://localhost:64990/ping/${renderId}` // the proxy will handle sending to /api/render/update

	const script = buildLoadscript(scriptText, {
		ASSET_ID: relativeName.toString(), // TODO: make not string
		BASE_URL: config.Domain,
		PING_URL: pingUrl,
		RENDER_TYPE: renderType,
	})

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
		await failRender(renderId)
		throw e
	}
}
