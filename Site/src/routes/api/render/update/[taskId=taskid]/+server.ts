import { error } from "@sveltejs/kit"
import { RCC_KEY } from "$env/static/private"
import { db, Record } from "$lib/server/surreal"
import completeQuery from "./complete.surql"
import renderQuery from "./render.surql"

type Render = {
	type: "Clothing" | "Avatar"
	relativeId: number
}

export async function POST({ params, request }) {
	// get bearer token from header instead of insecure url
	const auth = request.headers.get("Authorization")
	if (!auth || !auth.startsWith("Bearer ") || auth.slice(7) !== RCC_KEY)
		throw error(403, "Stfu")

	const render = Record("render", params.taskId)
	const [[task]] = await db.query<Render[][]>(renderQuery, { render })
	if (!task) error(404, "Task not found")

	// More stuff is done with the proxy now, so we don't need to gunzip it

	// content has the following format:
	// {status}
	// {bodylen [4]}{headlen [4]}{body}{head}
	const content = new Uint8Array(await request.bytes())
	// console.log("Request size", content.length)

	const statusEnd = content.indexOf(10) // 10 is the ASCII code for newline
	const status = new TextDecoder().decode(content.slice(0, statusEnd))
	// console.log("Status:", status)

	let clickHead: Uint8Array | undefined
	let clickBody: Uint8Array | undefined

	const rest = content.slice(statusEnd + 1)
	if (rest.length > 8) {
		const dv = new DataView(rest.buffer, 0, 8)
		const bodylen = dv.getUint32(0)
		const headlen = dv.getUint32(4)
		// console.log("Body length", bodylen, "Head length", headlen)

		if (bodylen > 0) clickBody = rest.slice(8, bodylen)
		if (headlen > 0) clickHead = rest.slice(8 + bodylen, bodylen + headlen)
	}

	if (status === "Rendering") {
		await db.merge(render, { status: "Rendering" })
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

	await db.query(completeQuery, { render })
	return new Response()
}
