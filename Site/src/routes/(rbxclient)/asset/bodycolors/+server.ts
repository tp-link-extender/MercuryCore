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

const xmlHeaders = {
	Pragma: "no-cache",
	"Cache-Control": "no-cache",
	"Content-Type": "text/xml",
}

export async function GET({ url }) {
	const username = url.searchParams.get("username")?.trim()
	const bodyColoursXml = await Bun.file("xml/bodyColours.xml").text()

	if (!username)
		return new Response(
			bodyColoursXml
				.replace("_HEAD", "1")
				.replace("_LEFT_ARM", "1")
				.replace("_LEFT_LEG", "1")
				.replace("_RIGHT_ARM", "1")
				.replace("_RIGHT_LEG", "1")
				.replace("_TORSO", "1"),
			{ headers: xmlHeaders }
		)

	const [[user]] = await db.query<User[][]>(bodyColoursQuery, { username })
	if (!user) error(404, "User not found")

	const colours = user.bodyColours
	const res = bodyColoursXml
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
			"Content-Type": "text/xml",
		},
	})
}
