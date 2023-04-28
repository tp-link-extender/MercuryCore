// "'Hooks' are app-wide functions you declare that SvelteKit will call in response to
// specific events, giving you fine-grained control over the framework's behaviour."

// See https://kit.svelte.dev/docs/hooks/ for more info.

import { dev } from "$app/environment"
import { auth } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { client } from "$lib/server/redis"
import { redirect } from "@sveltejs/kit"

// Ran every time a request is made
export async function handle({ event, resolve }) {
	event.locals = auth.handleRequest(event)
	const { user, session } = await event.locals.validateUser()
	if (!session) return await resolve(event)

	if (
		!["/moderation", "/api", "/terms"].includes(event.url.pathname) &&
		(
			await prisma.moderationAction.findMany({
				where: {
					moderateeId: user.id,
					active: true,
				},
			})
		)[0]
	)
		throw redirect(302, "/moderation")

	await prisma.authUser.update({
		where: {
			id: user.id,
		},
		data: {
			lastOnline: new Date(),
		},
	})

	if (
		!(
			user.currencyCollected.getTime() -
				(new Date().getTime() -
					1000 *
						3600 *
						Number((await client.get("stipendTime")) || 12)) >
			0
		)
	) {
		await prisma.authUser.update({
			where: {
				id: user.id,
			},
			data: {
				currencyCollected: new Date(),
				currency: {
					increment: Number((await client.get("dailyStipend")) || 10),
				},
			},
		})
	}

	return await resolve(event)
}

export const handleError = ({ error }) =>
	dev
		? console.error(error)
		: console.error(`[${new Date().toLocaleString()}] ${error}`)
