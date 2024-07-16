import { equery, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"

type User = {
	bodyColours: {
		Head: number
		Torso: number
		LeftArm: number
		RightArm: number
		LeftLeg: number
		RightLeg: number
	}
}

export async function GET({ params }) {
	const [[user]] = await equery<User[][]>(
		surql`SELECT bodyColours FROM user WHERE username = ${params.username}`
	)
	if (!user) error(404, "User not found")

	const colours = user.bodyColours
	const res = (await Bun.file("xml/bodyColours.xml").text())
		.replace("_HEAD", colours.Head.toString())
		.replace("_LEFT_ARM", colours.LeftArm.toString())
		.replace("_LEFT_LEG", colours.LeftLeg.toString())
		.replace("_RIGHT_ARM", colours.RightArm.toString())
		.replace("_RIGHT_LEG", colours.RightLeg.toString())
		.replace("_TORSO", colours.Torso.toString())

	return new Response(res, {
		headers: {
			Pragma: "no-cache",
			"Cache-Control": "no-cache",
			"Content-Type": "text/plain",
		},
	})
}
