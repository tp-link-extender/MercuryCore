import surql from "$lib/surrealtag"
import { query, squery } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import "dotenv/config"

export async function GET({ url, setHeaders }) {
	const userNumber = url.searchParams.get("userID")

	if (!userNumber || !/^\d+$/.test(userNumber))
		throw error(400, "Missing userID parameter")

	const user = await squery<{
		bodyColours: {
			Head: number
			Torso: number
			LeftArm: number
			RightArm: number
			LeftLeg: number
			RightLeg: number
		}
		wearing: number[]
	}>(
		surql`
			SELECT
				bodyColours,
				(SELECT
					meta::id(id) as id
				FROM ->wearing->asset).id AS wearing
			FROM user WHERE number = $id`,
		{ id: parseInt(userNumber) },
	)

	if (!user) throw error(404, "User not found")

	let charApp = `${process.env.RBX_ORIGIN}/Asset/BodyColors.ashx?id=${userNumber}`

	for (const asset of user.wearing) {
		charApp += `;${process.env.RBX_ORIGIN}/asset?id=${asset}`
	}

	setHeaders({
		Pragma: "no-cache",
		"Cache-Control": "no-cache",
	})

	return new Response(charApp)
}
