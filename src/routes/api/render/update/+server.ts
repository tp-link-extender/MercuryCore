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
	if (!apiKey || apiKey != process.env.RCC_KEY) throw error(400, "Stfu")

	const id = url.searchParams.get("taskID")
	if (!id || !/^[\d\w]+$/.test(id))
		throw error(400, "Missing taskID parameter")

	const task = await squery<Render>(surql`SELECT * FROM $render`, {
		render: `render:${id}`,
	})

	if (!task) throw error(404, "Task not found")

	// Check if response is gzipped, and if so, gunzip it
	const buffer = await request.arrayBuffer()

	if (buffer.byteLength < 2) throw error(400, "Request too short or empty")

	const buffer2 = new Uint8Array(buffer),
		headerBytes = buffer2.slice(0, 2)
	const json = JSON.parse(
		headerBytes[0] == 0x1f && headerBytes[1] == 0x8b
			? gunzipSync(buffer2).toString()
			: new TextDecoder().decode(buffer2),
	)

	const status: "Rendering" | "Completed" = json.Status,
		typeAvatar = task.type == "Avatar"

	console.log(status)

	if (status == "Rendering")
		await query(surql`UPDATE $render SET status = "Rendering"`, {
			render: `render:${id}`,
		})
	else if (status == "Completed") {
		const click: string | undefined = json?.Click,
			clickBody: string | undefined = json?.ClickBody,
			clickHead: string | undefined = json?.ClickHead

		// Convert base64 from RCCService to an image
		if (click) {
			const path = `data/${typeAvatar ? "avatars" : "thumbnails"}/${
				task.relativeId
			}${typeAvatar ? ".png" : ""}`

			await sharp(Buffer.from(click, "base64"))
				.resize(420, 420)
				.png()
				.toFile(path)
				.catch(() => {
					throw new Error("Failed to resize image")
				})
		} else if (clickBody && clickHead) {
			const path = (s: string) =>
				`data/${typeAvatar ? "avatars" : "thumbnails"}/${
					task.relativeId
				}${s}${typeAvatar ? ".png" : ""}`

			await Promise.all([
				sharp(Buffer.from(clickHead, "base64"))
					.resize(150, 150)
					.png()
					.toFile(path("-head"))
					.catch(() => {
						throw new Error("Failed to resize head image")
					}),
				sharp(Buffer.from(clickBody, "base64"))
					.resize(420, 420)
					.png()
					.toFile(path("-body"))
					.catch(() => {
						throw new Error("Failed to resize body image")
					}),
			])
		}

		await query(
			surql`
				UPDATE $render MERGE {
					status: "Completed",
					completed: time::now(),
				}`,
			{ render: `render:${id}` },
		)
	}

	return new Response()
}
