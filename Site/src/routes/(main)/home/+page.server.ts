import filter from "$lib/server/filter.js"
import formError from "$lib/server/formError"
import { authorise } from "$lib/server/lucia"
import ratelimit from "$lib/server/ratelimit"
import { db, Record } from "$lib/server/surreal"
import { zod } from "sveltekit-superforms/adapters"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"
import homeQuery from "./home.surql"
import statusQuery from "./status.surql"

const schema = z.object({
	status: z.string().min(1).max(1000),
})

type Place = {
	id: number
	name: string
	playerCount: number
	serverPing: number
	likeCount: number
	dislikeCount: number
}

type FeedPost = {
	authorUser: BasicUser
	content: {
		id: string
		text: string
		updated: string
	}[]
	id: string
	posted: string
	visibility: string
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
		[Place[], BasicUser[], FeedPost[]]
	>(homeQuery, { user: Record("user", user.id) })

	return {
		greet: greets[Math.floor(Math.random() * greets.length)](),
		form: await superValidate(zod(schema)),
		places,
		friends,
		feed,
	}
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ request, locals, getClientAddress }) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, zod(schema))
	if (!form.valid) return formError(form)

	const limit = ratelimit(form, "statusPost", getClientAddress, 30)
	if (limit) return limit

	const unfiltered = form.data.status.trim()
	if (!unfiltered)
		return formError(form, ["status"], ["Status cannot be empty"])

	await db.query(statusQuery, {
		content: filter(unfiltered),
		user: Record("user", user.id),
	})
}
