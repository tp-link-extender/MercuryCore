import { prisma } from "$lib/server/prisma"
import render from "$lib/server/render"
import fs from "fs"
import { error } from "@sveltejs/kit"

export async function GET({ params }) {
	let { username } = params
	if (!username) throw error(400, "Invalid Request")

	let bodyShot = ""
	if (username.endsWith("-body")) {
		username = username.replace("-body", "")
		bodyShot = "-body"
	}
	const user = await prisma.authUser.findUnique({
		where: {
			username,
		},
		select: {
			bodyColours: true,
		},
	})

	if (!user) throw error(404, "User not found")

	if (!fs.existsSync(`data/avatars/${username}${bodyShot}.webp`))
		if (bodyShot) await render(username, user.bodyColours, true)
		else await render(username, user.bodyColours)

	return new Response(
		fs.readFileSync(`data/avatars/${username}${bodyShot}.webp`),
	)
}
