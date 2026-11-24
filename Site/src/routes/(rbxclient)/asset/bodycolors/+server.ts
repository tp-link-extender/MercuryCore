import { error } from "@sveltejs/kit"
import { bodyColoursOf } from "#lib/server/db/appearance.ts"
import { fillXmlTemplate } from "#lib/server/xmlTemplate.ts"
import type { RequestEvent } from "./$types"

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

	const colours = await bodyColoursOf(username)
	if (!colours) error(404, "User not found")

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
