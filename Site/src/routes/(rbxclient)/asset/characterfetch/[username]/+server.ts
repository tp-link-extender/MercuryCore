import { error } from "@sveltejs/kit"
import config from "$lib/server/config"
import { db } from "$lib/server/surreal"
import userQuery from "./user.surql"

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
	const [[user]] = await db.query<User[][]>(userQuery, { username })
	if (!user) error(404, "User not found")

	let charApp = `http://${config.DomainInsecure}/asset/bodycolours/${username}?`
	for (const asset of user.wearing)
		charApp += `;http://${config.DomainInsecure}/asset?id=${asset}`

	return new Response(charApp, {
		headers: {
			Pragma: "no-cache",
			"Cache-Control": "no-cache",
			"Content-Type": "text/plain",
		},
	})
}
