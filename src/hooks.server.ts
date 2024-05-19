// "'Hooks' are app-wide functions you declare that SvelteKit will call in response to
// specific events, giving you fine-grained control over the framework's behaviour."

// See https://kit.svelte.dev/docs/hooks/ for more info.

import { equery, RecordId, surrealql } from "$lib/server/surreal"
import { auth } from "$lib/server/lucia"
import { dev } from "$app/environment"
import { redirect } from "@sveltejs/kit"
import pc from "picocolors"
import type { Cookie } from "lucia"

const { magenta, red, yellow, green, blue, gray: grey, cyan } = pc
const methodColours = Object.freeze({
	GET: green("GET"),
	POST: yellow("POST"),
})
const pathnameColours = Object.freeze({
	"/api": green,
	"/download": yellow,
	"/moderation": yellow,
	"/report": yellow,
	"/statistics": yellow,
	"/register": blue,
	"/login": blue,
	"/place": magenta,
	"/admin": red,
	"/studio": cyan,
})

const pathnameColour = (pathname: string) => {
	for (const [prefix, colour] of Object.entries(pathnameColours))
		if (pathname.startsWith(prefix)) return colour(pathname)
	return pathname
}

// Ran every time a dynamic request is made.
// Requests for prerendered pages do not trigger this hook.
export async function handle({ event, resolve }) {
	const { pathname, search } = event.url

	async function finish() {
		const method = event.request.method as keyof typeof methodColours
		const { user } = event.locals // is this needed here?

		// Fancy logging: time, user, method, and path
		console.log(
			`${grey(new Date().toLocaleString())} `,
			user
				? blue(user.username) + " ".repeat(21 - user.username.length)
				: yellow("Logged-out user      "),
			(methodColours[method] || method) + " ".repeat(7 - method.length),
			pathnameColour(decodeURI(pathname) + search)
		)

		const isStudio = event.request.headers
			.get("user-agent")
			?.includes("RobloxStudio/2013")

		if (
			isStudio &&
			!pathname.startsWith("/studio") &&
			!pathname.startsWith("/api")
		) {
			// trim trailing slash
			const newPathname = pathname.replace(/\/+$/, "")
			redirect(302, `/studio${newPathname}`)
		}

		const res = await resolve(event)

		// if it's html, add the user's custom css before the </body> tag
		if (
			res.headers.get("content-type")?.includes("text/html") &&
			user?.css
		) {
			// duplicate the response to avoid modifying the original
			const text = await res.clone().text()

			return new Response(
				text.replace(
					"</body>",
					`<style id="custom-css">${user.css}</style></body>`
				),
				{
					status: res.status,
					statusText: res.statusText,
					headers: res.headers,
				}
			)
		}

		return res
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
		// sveltekit types deviate from the de facto standard here
		event.cookies.set(sessionCookie.name, sessionCookie.value, {
			path: ".",
			...sessionCookie.attributes,
		})

	if (!session) setSession(auth.createBlankSessionCookie())
	else if (session.fresh) setSession(auth.createSessionCookie(session.id))

	const [[moderated]] = await equery<1[][]>(
		surrealql`
			SELECT 1 FROM moderation
			WHERE out = $user AND active = true`,
		{ user: new RecordId("user", user.id) }
	)

	if (
		moderated &&
		!["/moderation", "/terms", "/privacy", "/api"].includes(pathname) &&
		!pathname.startsWith("/api/avatar") &&
		!pathname.startsWith("/studio")
	)
		redirect(302, "/moderation")

	await equery(surrealql`UPDATE $user SET lastOnline = time::now()`, {
		user: new RecordId("user", user.id),
	})

	const [[economy]] = await equery<
		{
			dailyStipend?: number
			stipendTime?: number
		}[][]
	>(surrealql`SELECT * FROM stuff:economy`)

	const dailyStipend = economy?.dailyStipend || 10
	const stipendTime = economy?.stipendTime || 12

	if (
		new Date(user.currencyCollected).getTime() -
			(new Date().getTime() - 3600e3 * stipendTime) <
		0
	)
		await equery(
			surrealql`
				UPDATE $user SET currencyCollected = time::now();
				UPDATE $user SET currency += $dailyStipend`,
			{
				user: new RecordId("user", user.id),
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
			`${grey(new Date().toLocaleString())} `,
			user
				? blue(user.username) + " ".repeat(21 - user.username.length)
				: yellow("Logged-out user      "),
			red(error as string)
		)
}
