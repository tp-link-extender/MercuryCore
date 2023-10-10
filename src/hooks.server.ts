// "'Hooks' are app-wide functions you declare that SvelteKit will call in response to
// specific events, giving you fine-grained control over the framework's behaviour."

// See https://kit.svelte.dev/docs/hooks/ for more info.

import surql from "$lib/surrealtag"
import { squery } from "$lib/server/surreal"
import { dev } from "$app/environment"
import { auth } from "$lib/server/lucia"
import surreal from "$lib/server/surreal"
import { redirect } from "@sveltejs/kit"
import pc from "picocolors"

const { magenta, red, yellow, green, blue, gray } = pc,
	methodColours: { [k: string]: string } = {
		GET: green("GET"),
		POST: yellow("POST"),
	},
	pathnameColour = (pathname: string) =>
		pathname.startsWith("/api")
			? green(pathname)
			: pathname.startsWith("/download") ||
			  pathname.startsWith("/moderation") ||
			  pathname.startsWith("/report") ||
			  pathname.startsWith("/statistics")
			? yellow(pathname)
			: pathname.startsWith("/register") || pathname.startsWith("/login")
			? blue(pathname)
			: pathname.match(/^\/place\/\d+\/.*\/icon$/)
			? magenta(pathname)
			: pathname.startsWith("/admin")
			? red(pathname)
			: pathname

// Ran every time a dynamic request is made.
// Requests for prerendered pages do not trigger this hook.
export async function handle({ event, resolve }) {
	event.locals.auth = auth.handleRequest(event)
	const session = await event.locals.auth.validate(),
		user = session?.user,
		{ pathname, search } = event.url,
		{ method } = event.request

	// Fancy logging: time, user, method, and path
	console.log(
		gray(new Date().toLocaleString()) + " ",
		user
			? blue(user.username) + " ".repeat(21 - user.username.length)
			: yellow("Logged-out user      "),
		(methodColours[method] || method) + " ".repeat(7 - method.length),
		pathnameColour(decodeURI(pathname) + search),
	)

	if (!session || !user) return await resolve(event)

	const moderation = (
		(await squery(
			surql`
				SELECT *
				FROM moderation
				WHERE out = $user
					AND active = true`,
			{ user: `user:${user.id}` },
		)) as {}[]
	)[0]

	if (
		!["/moderation", "/terms", "/privacy", "/api"].includes(pathname) &&
		!pathname.startsWith("/api/avatar") &&
		moderation
	)
		throw redirect(302, "/moderation")

	await squery(surql`UPDATE $user SET lastOnline = time::now()`, {
		user: `user:${user.id}`,
	})

	const economy = (await surreal.select("stuff:economy"))[0],
		dailyStipend = (economy?.dailyStipend as number) || 10

	if (
		user.currencyCollected.getTime() -
			(new Date().getTime() - 3600_000 * dailyStipend) <
		0
	)
		await squery(
			surql`
				UPDATE $user SET currencyCollected = time::now();
				UPDATE $user SET currency += $dailyStipend`,
			{
				user: `user:${user.id}`,
				dailyStipend,
			},
		)

	return resolve(event)
}

export const handleError = async ({ event, error }) => {
	const session = await event.locals.auth?.validate(),
		user = session?.user

	// Fancy error logging: time, user, and error
	console.error(
		dev
			? error
			: (gray(new Date().toLocaleString()) + " ",
			  user
					? blue(user.username) +
					  " ".repeat(21 - user.username.length)
					: yellow("Logged-out user      "),
			  red(error as string)),
	)
}
