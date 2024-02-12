import { query, squery, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import "dotenv/config"
import { gunzipSync } from "node:zlib"
import sharp from "sharp"

type Render = {
	id: number
	type: "Clothing" | "Avatar"
	status: "Pending" | "Rendering" | "Completed" | "Error"
	created: string
	completed: string | null
	relativeId: number
}

export async function POST({ request, url }) {
	const apiKey = url.searchParams.get("apiKey")
	if (!apiKey || apiKey !== process.env.RCC_KEY) error(403, "Stfu")

	const id = url.searchParams.get("taskID")
	if (!id || !/^[\d\w]+$/.test(id)) error(400, "Missing taskID parameter")

	const task = await squery<Render>(surql`SELECT * FROM $render`, {
		render: `render:${id}`,
	})

	if (!task) error(404, "Task not found")

	// Check if response is gzipped, and if so, gunzip it
	const buffer = await request.arrayBuffer()
	const headerBytes = new Uint8Array(buffer).slice(0, 2)
	const gzipped = headerBytes[0] === 0x1f && headerBytes[1] === 0x8b

	// request.headers.get("content-encoding") == "gzip"
	// This doesn't work because RCC is a LIAR!!!!
	// we could do this with the proxy but whatever

	console.log("buffer", buffer)
	console.log("gzipped", gzipped)

	const data = gzipped
		? gunzipSync(buffer).toString()
		: new TextDecoder().decode(buffer)

	const [status, clickBody, clickHead] = data.split("\n")
	const typeAvatar = task.type === "Avatar"

	console.log("Render status update:", status)

	if (status === "Rendering")
		await query(surql`UPDATE $render SET status = "Rendering"`, {
			render: `render:${id}`,
		})
	else if (status === "Completed") {
		// Less repetitive and more readable
		const sharpen = (input: string, size: number, name = "") =>
			sharp(Buffer.from(input, "base64"))
				.resize(size, size)
				.png()
				.toFile(
					`data/${typeAvatar ? "avatars" : "thumbnails"}/${
						task.relativeId
					}${name && "-"}${name}${typeAvatar ? ".png" : ""}`
				)
				.catch(() => {
					throw new Error(`Failed to resize ${name} image`)
				})

		// Convert base64 from RCCService to an image
		if (clickHead && clickBody)
			await Promise.all([
				sharpen(clickHead, 150, "head"),
				sharpen(clickBody, 420, "body"),
			])
		else if (clickBody) await sharpen(clickBody, 420)

		await query(
			surql`
				UPDATE $render MERGE {
					status: "Completed",
					completed: time::now(),
				}`,
			{ render: `render:${id}` }
		)
	}

	return new Response()
}
