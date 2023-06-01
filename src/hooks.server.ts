// "'Hooks' are app-wide functions you declare that SvelteKit will call in response to
// specific events, giving you fine-grained control over the framework's behaviour."

// See https://kit.svelte.dev/docs/hooks/ for more info.

import { dev } from "$app/environment"
import { auth } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { client } from "$lib/server/redis"
import { redirect } from "@sveltejs/kit"
import { magenta, red, yellow, green, blue, gray } from "picocolors"

const methodColours: { [k: string]: string } = {
	GET: green("GET"),
	POST: yellow("POST"),
}

function pathnameColour(pathname: string) {
	if (pathname.startsWith("/api")) return green(pathname)

	if (
		pathname.startsWith("/download") ||
		pathname.startsWith("/moderation") ||
		pathname.startsWith("/report") ||
		pathname.startsWith("/statistics")
	)
		return yellow(pathname)

	if (pathname.startsWith("/register") || pathname.startsWith("/login"))
		return blue(pathname)

	if (pathname.match(/^\/place\/\d+\/.*\/icon$/)) return magenta(pathname)

	if (pathname.startsWith("/admin")) return red(pathname)

	return pathname
}

// Ran every time a dynamic request is made.
// Requests for prerendered pages do not trigger this hook.
export async function handle({ event, resolve }) {
	event.locals = auth.handleRequest(event)
	const { user, session } = await event.locals.validateUser()
	const { pathname, search } = event.url
	const { method, body } = event.request

	// Fancy logging: time, user, method, and path
	console.log(
		gray(new Date().toLocaleString()) + " ",
		user
			? blue(user.username) + " ".repeat(21 - user.username.length)
			: yellow("Logged-out user      "),
		(methodColours[method] || method) + " ".repeat(7 - method.length),
		pathnameColour(decodeURI(pathname) + search)
	)

	if (!session) return await resolve(event)

	if (
		!["/moderation", "/terms"].includes(pathname) &&
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

export const handleError = async ({ event, error }) => {
	const { user } = await event.locals.validateUser()

	// Fancy error logging: time, user, and error
	if (dev) console.error(error)
	else
		console.error(
			gray(new Date().toLocaleString()) + " ",
			user
				? blue(user.username) + " ".repeat(21 - user.username.length)
				: yellow("Logged-out user      "),
			red(error as string)
		)
}
