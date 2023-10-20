import render from "$lib/server/render"
import { squery, surql } from "$lib/server/surreal"
import fs from "fs"
import { error } from "@sveltejs/kit"

export async function GET({ params, setHeaders }) {
	let { username } = params
	if (!username) throw error(400, "Invalid Request")

	let bodyShot = ""
	if (username.endsWith("-body")) {
		username = username.replace("-body", "")
		bodyShot = "-body"
	}
	const user = await squery<{
		bodyColours: {
			Head: number
			Torso: number
			LeftArm: number
			RightArm: number
			LeftLeg: number
			RightLeg: number
		}
	}>(
		surql`
			SELECT bodyColours FROM user
			WHERE username = $username`,
		{ username },
	)

	if (!user) throw error(404, "User not found")

	if (!fs.existsSync(`data/avatars/${username}${bodyShot}.webp`))
		if (bodyShot) await render(username, user.bodyColours, true)
		else await render(username, user.bodyColours)

	setHeaders({
		"Cache-Control": "max-age=5",
	})

	return new Response(
		fs.readFileSync(`data/avatars/${username}${bodyShot}.webp`),
	)
}
