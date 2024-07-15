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
	wearing: number[]
}

export async function GET({ params }) {
	const { username } = params
	const [[user]] = await equery<User[][]>(
		surql`
			SELECT
				bodyColours,
				(SELECT meta::id(id) AS id
				FROM ->wearing->asset).id AS wearing
			FROM user WHERE username = ${username}`
	)
	if (!user) error(404, "User not found")

	let charApp = `${process.env.DOMAIN}/asset/bodycolours/${username}`

	for (const asset of user.wearing)
		charApp += `;${process.env.DOMAIN}/asset?id=${asset}`

	return new Response(charApp, {
		headers: {
			Pragma: "no-cache",
			"Cache-Control": "no-cache",
			"Content-Type": "text/plain",
		},
	})
}
