import { Record, db } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import completeQuery from "./complete.surql"
import renderQuery from "./render.surql"

type Render = {
	type: "Clothing" | "Avatar"
	relativeId: number
}

export async function POST({ params, request, url }) {
	const apiKey = url.searchParams.get("apiKey")
	if (!apiKey || apiKey !== process.env.RCC_KEY) error(403, "Stfu")

	const render = Record("render", params.taskId)
	const [[task]] = await db.query<Render[][]>(renderQuery, { render })
	if (!task) error(404, "Task not found")

	// More stuff is done with the proxy now, so we don't need to gunzip it

	// content has the following format:
	// {status}
	// {bodylen [4]}{headlen [4]}{body}{head}
	const content = new Uint8Array(await request.bytes())
	const statusEnd = content.indexOf(10) // 10 is the ASCII code for newline
	const status = new TextDecoder().decode(content.slice(0, statusEnd))

	let clickHead: Uint8Array | undefined
	let clickBody: Uint8Array | undefined

	const rest = content.slice(statusEnd + 1)
	if (rest.length > 8) {
		const dv = new DataView(rest.buffer, 0, 8)
		const bodylen = dv.getUint32(0)
		const headlen = dv.getUint32(4)

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
