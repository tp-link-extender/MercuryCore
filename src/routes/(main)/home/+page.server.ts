import surql from "$lib/surrealtag"
import { authorise } from "$lib/server/lucia"
import { findPlaces } from "$lib/server/prisma"
import { squery } from "$lib/server/surreal"
import ratelimit from "$lib/server/ratelimit"
import formError from "$lib/server/formError"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	status: z.string().min(1).max(1000),
})

export async function load({ locals }) {
	const { user } = await authorise(locals),
		// (main)/+layout.server.ts will handle most redirects for logged-out users,
		// but sometimes errors for this page.

		greets = [`Hi, ${user.username}!`, `Hello, ${user.username}!`],
		facts = [
			`You joined mercury on ${user?.accountCreated
				.toLocaleString()
				.substring(0, 10)}!`,
			// Add "st", "nd", "rd", "th" to number
			`You are the ${user?.number}${
				["st", "nd", "rd"][(user?.number % 10) - 1] || "th"
			} user to join Mercury!`,
		]

	return {
		stuff: {
			greet: greets[Math.floor(Math.random() * greets.length)],
			fact: facts[Math.floor(Math.random() * facts.length)],
		},
		form: superValidate(schema),
		places: findPlaces({
			where: {
				privateServer: false,
			},
			select: {
				name: true,
				id: true,
				gameSessions: {
					where: {
						ping: {
							gt: Math.floor(Date.now() / 1000) - 35,
						},
					},
				},
			},
		}),
		friends: squery(
			surql`
				SELECT number, username
				FROM $user->friends->user OR $user<-friends<-user`,
			{
				user: `user:${user.id}`,
			},
		) as Promise<
			{
				number: number
				username: string
			}[]
		>,
		feed: squery(surql`
			SELECT
				*,
				content[0] AS content,
				(SELECT number, username FROM <-posted<-user)[0] as authorUser
			FROM statusPost
			LIMIT 40`) as Promise<
			{
				authorUser: {
					number: number
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
			}[]
		>,
		// prisma.post.findMany({
		// 	select: {
		// 		id: true,
		// 		content: true,
		// 		posted: true,
		// 		authorUser: {
		// 			select: {
		// 				username: true,
		// 				number: true,
		// 			},
		// 		},
		// 	},
		// 	orderBy: {
		// 		posted: "desc",
		// 	},
		// 	take: 40,
		// }),
	}
}

export const actions = {
	default: async ({ request, locals, getClientAddress }) => {
		const form = await superValidate(request, schema)
		if (!form.valid) return formError(form)
		const limit = ratelimit(form, "statusPost", getClientAddress, 30)
		if (limit) return limit

		const { user } = await authorise(locals)

		await squery(
			surql`
			LET $textContent = CREATE textContent CONTENT {
				text: $content,
				updated: time::now(),
			};
			RELATE $user->wrote->$textContent;

			LET $status = CREATE statusPost CONTENT {
				posted: time::now(),
				visibility: "Visible",
				content: [$textContent],
			};
			RELATE $user->posted->$status`,
			{
				content: form.data.status,
				user: `user:${user.id}`,
			},
		)
	},
}
