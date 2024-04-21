import { squery, surql } from "$lib/server/surreal"
import fs from "node:fs"
import { error } from "@sveltejs/kit"

export async function GET({ url, params }) {
	let { username } = params
	if (!username) error(400, "Invalid Request")

	const wait = url.searchParams.has("wait")

	let shotType = "-head"
	if (username.endsWith("-body")) {
		username = username.replace("-body", "")
		shotType = "-body"
	}

	const user = await squery<{
		number: number
	}>(surql`SELECT number FROM user WHERE username = $username`, { username })

	if (!user) error(404, "User not found")

	const path = `data/avatars/${user.number}${shotType}.png`

	try {
		if (wait) {
			// If the file doesn't exist, wait for it to be created
			// if it does exist, wait for it to be modified
			console.log("waiting...")
			await new Promise<void>(resolve => {
				try {
					const watcher = fs.watch(path, () => {
						watcher.close()
						resolve()
					})
				} catch {
					resolve()
				}
			})

			console.log("waited")
		} else if (!(await Bun.file(path).exists())) throw new Error()

		return new Response(Bun.file(path))
	} catch {
		return new Response(Bun.file("static/m....png"))
	}
}
