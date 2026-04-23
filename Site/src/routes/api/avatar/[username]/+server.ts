import fs from "node:fs"
import { error } from "@sveltejs/kit"
import { db, type RecordId } from "$lib/server/surreal"

const timeout = 10 // seconds

export async function GET({ params, url }) {
	let { username } = params
	if (!username) error(400, "Invalid Request")

	const wait = url.searchParams.has("wait")

	let shotType = "-head"
	if (username.endsWith("-body")) {
		username = username.replace("-body", "")
		shotType = "-body"
	}

	const [[user]] = await db.query<{ id: RecordId<"user"> }[][]>(
		"SELECT id FROM user WHERE username = $username",
		{ username }
	)
	if (!user) error(404, "User not found")

	const path = `../data/avatars/${user.id.id}${shotType}.png`

	try {
		if (wait)
			// If the file doesn't exist, wait for it to be created
			// if it does exist, wait for it to be modified

			await Promise.race([
				new Promise<void>(resolve => {
					try {
						const watcher = fs.watch(path, () => {
							watcher.close()
							resolve()
						})
					} catch {
						resolve()
					}
				}),
				// ...but don't wait forever
				new Promise(resolve => setTimeout(resolve, timeout * 1000)),
			])
		else if (!(await Bun.file(path).exists()))
			throw new Error("File does not exist")

		return new Response(Bun.file(path))
	} catch {
		return new Response(Bun.file("static/dots.png"))
	}
}
