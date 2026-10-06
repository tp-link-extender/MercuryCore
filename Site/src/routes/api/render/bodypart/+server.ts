import { error } from "@sveltejs/kit"
import { assetRegex } from "$lib/paramTests"
import config from "$lib/server/config"
import { db, Record } from "$lib/server/surreal"
import typeQuery from "./type.surql"

// the clothing worn by the render rig depends on which body part is rendered
// (hardcoded for prod)
const bodyPartClothing = Object.freeze({
	27: 337622528, // Torso
	28: 999521121, // Right Arm
	29: 579211518, // Left Arm
	30: 646628080, // Left Leg
	31: 663653540, // Right Leg
})

// Returns a character appearance that equips the body part in question plus
// its matching item of clothing, used by RCC (renderBodyPart.luau)
export async function GET({ url }) {
	const id = url.searchParams.get("id")
	if (!id || !assetRegex.test(id)) error(400, "Missing id parameter")

	const [[asset]] = await db.query<{ type: number }[][]>(typeQuery, {
		asset: Record("asset", +id),
	})
	if (!asset) error(404, "Not Found")

	const clothing =
		bodyPartClothing[asset.type as keyof typeof bodyPartClothing]
	if (!clothing) error(400, "Not a body part asset")

	const charApp = [
		`http://${config.DomainInsecure}/asset/bodycolors.ashx?`,
		`http://${config.Domain}/asset?id=${id}`,
		`http://${config.Domain}/asset?id=${clothing}`,
	].join(";")

	return new Response(charApp, {
		headers: {
			Pragma: "no-cache",
			"Cache-Control": "no-cache",
		},
	})
}
