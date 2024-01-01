import { authorise } from "$lib/server/lucia"
import { query, surql } from "$lib/server/surreal"
import ratelimit from "$lib/server/ratelimit"
import formError from "$lib/server/formError"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	status: z.string().min(1).max(1000),
})

export async function load({ locals }) {
	const { user } = await authorise(locals)
	// (main)/+layout.server.ts will handle most redirects for logged-out users,
	// but sometimes errors for this page.

	// for the "You are the 1st user to join Mercury!" fact
	const suffixes: { [k: string]: string } = {
		one: "st",
		two: "nd",
		few: "rd",
		other: "th",
	}
	const ordinals = new Intl.PluralRules("en", { type: "ordinal" }),
		ordinal = (n: number) => `${n}${suffixes[ordinals.select(n)]}`,
		greets = [`Hi, ${user.username}!`, `Hello, ${user.username}!`]
	const facts = [
		`You joined mercury on ${user?.accountCreated
			.toLocaleString()
			.substring(0, 10)}!`,
		// Add "st", "nd", "rd", "th" to number
		`You are the ${ordinal(user?.number)} user to join Mercury!`,
	]

	return {
		stuff: {
			greet: greets[Math.floor(Math.random() * greets.length)],
			fact: facts[Math.floor(Math.random() * facts.length)],
		},
		form: await superValidate(schema),
		places: await query<{
			id: number
			name: string
			playerCount: number
			serverPing: number
			likeCount: number
			dislikeCount: number
		}>(surql`
			SELECT
				meta::id(id) AS id,
				name,
				serverPing,
				count(
					SELECT * FROM <-playing
					WHERE valid
						AND ping > time::now() - 35s
				) AS playerCount,
				count(<-likes) AS likeCount,
				count(<-dislikes) AS dislikeCount
			FROM place
			WHERE !privateServer AND !deleted`),
		friends: await query<{
			number: number
			status: "Playing" | "Online" | "Offline"
			username: string
		}>(
			surql`
				SELECT
					number,
					status,
					username
				FROM $user->friends->user OR $user<-friends<-user`,
			{ user: `user:${user.id}` }
		),
		feed: await query<{
			authorUser: {
				number: number
				status: "Playing" | "Online" | "Offline"
				username: string
			}
			content: {
				id: string
				text: string
				updated: string
			}[]
			id: string
			posted: string
			visibility: string
		}>(surql`
			SELECT
				*,
				(SELECT text, updated FROM $parent.content
				ORDER BY updated DESC) AS content,
				(SELECT
					number,
					status,
					username
				FROM <-posted<-user)[0] as authorUser
			FROM statusPost
			LIMIT 40`),
	}
}

export const actions = {
	default: async ({ request, locals, getClientAddress }) => {
		const form = await superValidate(request, schema)
		if (!form.valid) return formError(form)
		const limit = ratelimit(form, "statusPost", getClientAddress, 30)
		if (limit) return limit

		const { user } = await authorise(locals)

		await query(
			surql`
				LET $status = CREATE statusPost CONTENT {
					posted: time::now(),
					visibility: "Visible",
					content: [{
						text: $content,
						updated: time::now(),
					}],
				};
				RELATE $user->posted->$status`,
			{
				content: form.data.status,
				user: `user:${user.id}`,
			}
		)
	},
}
