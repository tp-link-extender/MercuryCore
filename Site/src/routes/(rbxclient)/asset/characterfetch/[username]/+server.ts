import { error } from "@sveltejs/kit"
import config from "#lib/server/config.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import type { RequestEvent } from "./$types"
import userQuery from "./user.surql"

interface User {
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

export async function GET({ params }: RequestEvent) {
	const { username } = params
	const [[user]] = await dbQuery<User[][]>(userQuery, { username })
	if (!user) error(404, "User not found")

	let charApp = `http://${config.DomainInsecure}/asset/bodycolors.ashx?username=${username}`
	for (const asset of user.wearing)
		charApp += `;https://${config.Domain}/asset?id=${asset}`

	return new Response(charApp, {
		headers: {
			"Cache-Control": "no-cache",
			"Content-Type": "text/plain",
			Pragma: "no-cache",
		},
	})
}
