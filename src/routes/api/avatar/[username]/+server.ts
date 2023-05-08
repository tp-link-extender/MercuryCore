import { prisma } from "$lib/server/prisma"
import render from "$lib/server/render"
import fs from "fs"
import { error } from "@sveltejs/kit"

export async function GET({ params, setHeaders }) {
	const { username } = params
	if (!username) throw error(400, "Invalid Request")

	const user = await prisma.authUser.findUnique({
		where: {
			username,
		},
		select: {
			bodyColours: true,
		},
	})

	if (!user) throw error(404, "User not found")

	// Remove body colours not needed for avatar headshot
	const colours: any = user.bodyColours
	delete colours.LeftLeg
	delete colours.RightLeg

	if (!fs.existsSync(`data/avatars/${username}.png`))
		await render(username, colours)

	setHeaders({
		"Cache-Control": "max-age=600",
	})

	return new Response(fs.readFileSync(`data/avatars/${username}.png`))
}
