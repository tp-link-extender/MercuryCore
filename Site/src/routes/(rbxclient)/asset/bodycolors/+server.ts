import { error } from "@sveltejs/kit"
import { dbQuery } from "#lib/server/db/query.ts"
import { fillXmlTemplate } from "#lib/server/xmlTemplate.ts"
import type { RequestEvent } from "./$types"
import bodyColoursQuery from "./bodyColours.surql"

interface User {
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
	"Cache-Control": "no-cache",
	"Content-Type": "text/xml",
	Pragma: "no-cache",
}

export async function GET({ url }: RequestEvent) {
	const username = url.searchParams.get("username")?.trim()
	const bodyColoursXml = await Bun.file("xml/bodyColours.xml").text()

	if (!username)
		return new Response(
			fillXmlTemplate(bodyColoursXml, {
				HEAD: 1,
				LEFT_ARM: 1,
				LEFT_LEG: 1,
				RIGHT_ARM: 1,
				RIGHT_LEG: 1,
				TORSO: 1,
			}),
			{ headers: xmlHeaders }
		)

	const [[user]] = await dbQuery<User[][]>(bodyColoursQuery, { username })
	if (!user) error(404, "User not found")

	const colours = user.bodyColours
	const res = fillXmlTemplate(bodyColoursXml, {
		HEAD: colours.Head,
		LEFT_ARM: colours.LeftArm,
		LEFT_LEG: colours.LeftLeg,
		RIGHT_ARM: colours.RightArm,
		RIGHT_LEG: colours.RightLeg,
		TORSO: colours.Torso,
	})

	return new Response(res, {
		headers: {
			"Cache-Control": "no-cache",
			"Content-Type": "text/xml",
			Pragma: "no-cache",
		},
	})
}
