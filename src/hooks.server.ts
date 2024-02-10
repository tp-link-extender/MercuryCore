// "'Hooks' are app-wide functions you declare that SvelteKit will call in response to
// specific events, giving you fine-grained control over the framework's behaviour."

// See https://kit.svelte.dev/docs/hooks/ for more info.

import { query, squery, surql } from "$lib/server/surreal"
import { dev } from "$app/environment"
import { auth } from "$lib/server/lucia"
import surreal from "$lib/server/surreal"
import { redirect } from "@sveltejs/kit"
import pc from "picocolors"
import type { Cookie } from "lucia"

const { magenta, red, yellow, green, blue, gray } = pc
const methodColours: { [k: string]: string } = {
	GET: green("GET"),
	POST: yellow("POST"),
}
const pathnameColour = (pathname: string) =>
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
	const { pathname, search } = event.url

	function finish() {
		const { method } = event.request
		const { user } = event.locals // is this needed?

		// Fancy logging: time, user, method, and path
		console.log(
			`${gray(new Date().toLocaleString())} `,
			user
				? blue(user.username) + " ".repeat(21 - user.username.length)
				: yellow("Logged-out user      "),
			(methodColours[method] || method) + " ".repeat(7 - method.length),
			pathnameColour(decodeURI(pathname) + search)
		)

		return resolve(event)
	}

	const sessionId = event.cookies.get(auth.sessionCookieName)

	if (!sessionId) {
		event.locals.session = null
		event.locals.user = null
		return await finish()
	}

	const { session, user } = await auth.validateSession(sessionId)

	if (!session || !user) return await finish()

	event.locals.session = session
	event.locals.user = user

	const setSession = (sessionCookie: Cookie) =>
		// sveltekit types deviates from the de facto standard
		// `as any` is usable too
		event.cookies.set(sessionCookie.name, sessionCookie.value, {
			path: ".",
			...sessionCookie.attributes,
		})

	if (!session) setSession(auth.createBlankSessionCookie())
	else if (session.fresh) setSession(auth.createSessionCookie(session.id))

	const moderation = await squery(
		surql`
			SELECT * FROM moderation
			WHERE out = $user AND active = true`,
		{ user: `user:${user.id}` }
	)

	if (
		!["/moderation", "/terms", "/privacy", "/api"].includes(pathname) &&
		!pathname.startsWith("/api/avatar") &&
		moderation
	)
		redirect(302, "/moderation")

	await query(surql`UPDATE $user SET lastOnline = time::now()`, {
		user: `user:${user.id}`,
	})

	const economy = (await surreal.select("stuff:economy"))[0]
	const dailyStipend = (economy?.dailyStipend as number) || 10

	if (
		new Date(user.currencyCollected).getTime() -
			(new Date().getTime() - 3600e3 * dailyStipend) <
		0
	)
		await query(
			surql`
				UPDATE $user SET currencyCollected = time::now();
				UPDATE $user SET currency += $dailyStipend`,
			{
				user: `user:${user.id}`,
				dailyStipend,
			}
		)

	return await finish()
}

export const handleError = async ({ event, error }) => {
	const user = event.locals.user

	// Fancy error logging: time, user, and error
	if (dev) console.error(error)
	else
		console.error(
			`${gray(new Date().toLocaleString())} `,
			user
				? blue(user.username) + " ".repeat(21 - user.username.length)
				: yellow("Logged-out user      "),
			red(error as string)
		)
}
