import { squery, surql } from "$lib/server/surreal"
import fs from "fs"
import { error } from "@sveltejs/kit"
import requestRender from "$lib/server/requestRender"

export async function GET({ url, params }) {
	let { username } = params
	if (!username) throw error(400, "Invalid Request")

	const wait = url.searchParams.has("wait")

	if (username.endsWith("-body")) username = username.replace("-body", "")

	const user = await squery<{
		bodyColours: {
			Head: number
			Torso: number
			LeftArm: number
			RightArm: number
			LeftLeg: number
			RightLeg: number
		}
		number: number
	}>(
		surql`
			SELECT bodyColours, number FROM user
			WHERE username = $username`,
		{ username },
	)

	if (!user) throw error(404, "User not found")

	try {
		if (wait) {
			// If the file doesn't exist, wait for it to be created
			// if it does exist, wait for it to be modified
			console.log("waiting...")
			await new Promise<void>(resolve => {
				try {
					const watcher = fs.watch(
						`data/avatars/${user.number}.png`,
						() => {
							watcher.close()
							resolve()
						},
					)
				} catch {
					resolve()
				}
			})

			console.log("waited")
		} else if (!fs.existsSync(`data/avatars/${user.number}.png`))
			throw new Error()

		return new Response(fs.readFileSync(`data/avatars/${user.number}.png`))
	} catch {
		return new Response(fs.readFileSync(`static/m....png`))
	}
}
