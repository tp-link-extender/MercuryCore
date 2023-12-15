import { squery, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import "dotenv/config"

export async function GET({ url }) {
	const userNumber = url.searchParams.get("userID")

	if (!userNumber || !/^\d+$/.test(userNumber))
		error(400, "Missing userID parameter")

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
		{ id: parseInt(userNumber) }
	)

	if (!user) error(404, "User not found")

	let charApp = `${process.env.RCC_ORIGIN}/asset/bodycolors?id=${userNumber}`

	for (const asset of user.wearing)
		charApp += `;${process.env.RCC_ORIGIN}/asset?id=${asset}`

	return new Response(charApp, {
		headers: {
			Pragma: "no-cache",
			"Cache-Control": "no-cache",
		},
	})
}
