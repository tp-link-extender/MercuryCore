import { Record, equery, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"

type Render = {
	type: "Clothing" | "Avatar"
	relativeId: number
}

const taskIdRegex = /^[\d\w]+$/
export async function POST({ request, url, params }) {
	const apiKey = url.searchParams.get("apiKey")
	if (!apiKey || apiKey !== process.env.RCC_KEY) error(403, "Stfu")

	const id = params.taskId
	if (!taskIdRegex.test(id)) error(400, "Invalid taskId parameter")

	const [[task]] = await equery<Render[][]>(
		surql`SELECT type, relativeId FROM $render`,
		{ render: Record("render", id) }
	)

	if (!task) error(404, "Task not found")

	const buffer = await request.arrayBuffer()

	// More stuff is done with the proxy now, so we don't need to gunzip it
	console.log("buffer", buffer)

	const [status, clickBody, clickHead] = new TextDecoder()
		.decode(buffer)
		.split("\n")
	const typeAvatar = task.type === "Avatar"

	console.log("Render status update:", status)

	if (status === "Rendering")
		await equery(surql`UPDATE $render SET status = "Rendering"`, {
			render: Record("render", id),
		})
	else if (status === "Completed") {
		// Less repetitive and more readable
		const write = (input: string, name = "") =>
			Bun.write(
				`data/${typeAvatar ? "avatars" : "thumbnails"}/${
					task.relativeId
				}${name && "-"}${name}${typeAvatar ? ".png" : ""}`,
				Buffer.from(input, "base64")
			)

		// Convert base64 from proxy to an image
		// todo make it multipart/form-data or something for lower bandwidth
		if (clickHead && clickBody)
			await Promise.all([
				write(clickHead, "head"),
				write(clickBody, "body"),
			])
		else if (clickBody) await write(clickBody)

		await equery(
			surql`
				UPDATE $render MERGE {
					status: "Completed",
					completed: time::now(),
				}`,
			{ render: Record("render", id) }
		)
	}

	return new Response()
}
