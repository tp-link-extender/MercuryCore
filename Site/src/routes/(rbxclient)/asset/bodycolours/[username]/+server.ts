import { error } from "@sveltejs/kit"
import { db } from "$lib/server/surreal"
import bodyColoursQuery from "./bodyColours.surql"

type User = {
	bodyColours: {
		Head: number
		LeftArm: number
		LeftLeg: number
		RightArm: number
		RightLeg: number
		Torso: number
	}
}

export async function GET({ params }) {
	const [[user]] = await db.query<User[][]>(bodyColoursQuery, params)
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
