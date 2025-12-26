import { type } from "arktype"
import { authorise } from "$lib/server/auth"
import createCommentQuery from "$lib/server/createComment.surql"
import filter from "$lib/server/filter"
import formError from "$lib/server/formError"
import ratelimit from "$lib/server/ratelimit"
import { db, Record } from "$lib/server/surreal"
import { arktype, superValidate } from "$lib/server/validate"
import homeQuery from "./home.surql"

const schema = type({
	status: "1 <= string <= 1000",
})

type Place = {
	id: number
	name: string
	playerCount: number
	serverPing: number
	likeCount: number
	dislikeCount: number
}

type Status = {
	id: string
	author: BasicUser
	created: Date
	currentContent: string
}

export async function load({ locals }) {
	const { user } = await authorise(locals)
	// (main)/+layout.server.ts will handle most redirects for logged-out users, but sometimes errors for this page.

	// lazy eval 💞
	const greets = [
		() => `Hi, ${user.username}!`,
		() => `Hello, ${user.username}!`,
	]

	const [places, friends, feed] = await db.query<
		[Place[], BasicUser[], Status[]]
	>(homeQuery, { user: Record("user", user.id) })

	return {
		greet: greets[Math.floor(Math.random() * greets.length)](),
		form: await superValidate(arktype(schema)),
		places,
		friends,
		feed,
	}
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ locals, request, getClientAddress }) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, arktype(schema))
	if (!form.valid) return formError(form)

	const unfiltered = form.data.status.trim()
	if (!unfiltered)
		return formError(form, ["status"], ["Status must have content"])

	const limit = ratelimit(form, "comment", getClientAddress, 5)
	if (limit) return limit

	await db.query(createCommentQuery, {
		content: filter(unfiltered),
		type: ["status"],
		user: Record("user", user.id),
	})
}
