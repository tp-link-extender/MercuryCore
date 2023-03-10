// "'Hooks' are app-wide functions you declare that SvelteKit will call in response to
// specific events, giving you fine-grained control over the framework's behaviour."

// See https://kit.svelte.dev/docs/hooks/ for more info.

import { auth } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { client } from "$lib/server/redis"
import { sequence } from "@sveltejs/kit/hooks"
import { handleHooks } from "@lucia-auth/sveltekit"

// Ran every time a request is made
export const handle = sequence(handleHooks(auth), async ({ event, resolve }) => {
	const { user, session } = await event.locals.validateUser()
	if (!session) return await resolve(event)

	await prisma.user.update({
		where: {
			id: user.userId,
		},
		data: {
			lastOnline: new Date(),
		},
	})

	if (!(user.currencyCollected.getTime() - (new Date().getTime() - 1000 * 3600 * Number((await client.get("stipendTime")) || 12)) > 0)) {
		await prisma.user.update({
			where: {
				id: user?.userId,
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
})
