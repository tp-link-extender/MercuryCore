import formError from "$lib/server/formError"
import { authorise } from "$lib/server/lucia"
import ratelimit from "$lib/server/ratelimit"
import { Record, equery } from "$lib/server/surreal"
import { zod } from "sveltekit-superforms/adapters"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"
import homeQuery from "./home.surql"
import statusQuery from "./status.surql"

const schema = z.object({
	status: z.string().min(1).max(1000),
})

// for the "You are the 1st user to join Mercury!" fact
const suffixes: { [k: string]: string } = Object.freeze({
	one: "st",
	two: "nd",
	few: "rd",
	other: "th",
})
const ordinals = new Intl.PluralRules("en", { type: "ordinal" })
// Add "st", "nd", "rd", "th" to number
const ordinal = (n: number) => `${n}${suffixes[ordinals.select(n)]}`

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
	const facts = [
		() =>
			`You joined Mercury on ${user?.accountCreated
				.toLocaleString()
				.substring(0, 10)}!`,
		() => `You are the ${ordinal(user?.number)} user to join Mercury!`,
	]

	const [places, friends, feed] = await equery<
		[Place[], BasicUser[], FeedPost[]]
	>(homeQuery, { user: Record("user", user.id) })

	return {
		stuff: {
			greet: greets[Math.floor(Math.random() * greets.length)](),
			fact: facts[Math.floor(Math.random() * facts.length)](),
		},
		form: await superValidate(zod(schema)),
		places,
		friends,
		feed,
	}
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ request, locals, getClientAddress }) => {
	const form = await superValidate(request, zod(schema))
	if (!form.valid) return formError(form)
	const limit = ratelimit(form, "statusPost", getClientAddress, 30)
	if (limit) return limit

	const { user } = await authorise(locals)

	const content = form.data.status.trim()
	if (!content) return formError(form, ["status"], ["Status cannot be empty"])

	await equery(statusQuery, {
		content,
		user: Record("user", user.id),
	})
}
