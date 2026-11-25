import { error } from "@sveltejs/kit"
import { bearerMatches } from "#lib/server/bearer.ts"
import {
	completeRender,
	markRendering,
	renderTask,
} from "#lib/server/db/renders.ts"
import { parseRenderUpdate } from "#lib/server/renderUpdate.ts"
import { ORBITER_KEY } from "$app/env/private"
import type { RequestEvent } from "./$types"

export async function POST({ params, request }: RequestEvent) {
	// get bearer token from header instead of insecure url
	if (!bearerMatches(request, ORBITER_KEY, "ORBITER_KEY")) error(403, "Stfu")

	const task = await renderTask(params.taskId)
	if (!task) error(404, "Task not found")

	// More stuff is done with the proxy now, so we don't need to gunzip it
	// content has the following format:
	// {status}
	// {bodylen [4]}{headlen [4]}{body}{head}
	const {
		body: clickBody,
		head: clickHead,
		status,
	} = parseRenderUpdate(new Uint8Array(await request.bytes()))

	if (status === "Rendering") {
		await markRendering(params.taskId)
		return new Response()
	}
	if (status !== "Completed") return new Response()

	const getPath = (name: string) =>
		task.type === "Avatar"
			? `../data/avatars/${task.relativeId}${name && "-"}${name}.png`
			: `../data/thumbnails/${task.relativeId}${name && "-"}${name}`
	const write = (input: Uint8Array, name = "") =>
		Bun.write(getPath(name), input) // much better than base64

	// you're such a clickhead
	if (clickHead && clickBody)
		await Promise.all([write(clickHead, "head"), write(clickBody, "body")])
	else if (clickBody) await write(clickBody)

	await completeRender(params.taskId)
	return new Response()
}
