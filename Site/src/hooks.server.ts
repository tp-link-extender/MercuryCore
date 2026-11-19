// "'Hooks' are app-wide functions you declare that SvelteKit will call in response to specific events, giving you fine-grained control over the framework's behaviour."
// See https://svelte.dev/docs/kit/hooks for more info.

import { redirect } from "@sveltejs/kit"
import type { Handle, HandleServerError } from "@sveltejs/kit/hooks"
import { stipend } from "economy/api"
import { User as EconUser } from "economy/types"
import pc from "picocolors"
import {
	cookieName,
	cookieOptions,
	validateSessionToken,
} from "#lib/server/auth.ts"
import config from "#lib/server/config.ts"
import { redactSearch } from "#lib/server/redact.ts"
import { styleText } from "#lib/server/styleText.ts"
import { db, Record } from "#lib/server/surreal.ts"
import moderatedQuery from "./moderated.surql"

const { magenta, red, yellow, green, blue, gray } = pc
const methodColours: { [_: string]: string } = Object.freeze({
	GET: green("GET"),
	POST: yellow("POST"),
})
const pathnameColours = Object.freeze({
	admin: red,
	api: green,
	download: yellow,
	login: blue,
	moderation: yellow,
	place: magenta,
	register: blue,
	report: yellow,
	statistics: yellow,
})

function pathnameColour(pathname: string) {
	for (const [prefix, colour] of Object.entries(pathnameColours))
		if (pathname.startsWith(`/${prefix}`)) return colour(pathname)

	return pathname
}

// Account recovery tokens are in the path, so they mustn't end up in logs
const redact = (pathname: string) =>
	pathname.startsWith("/recover/") ? "/recover/[redacted]" : pathname

// Malformed percent-encoding (such as /%FF) makes decodeURI throw, so log the raw path instead
function readablePath(pathname: string) {
	try {
		return decodeURI(pathname)
	} catch {
		return pathname
	}
}

const time = () =>
	config.Logging.Time ? gray(new Date().toLocaleString()) : ""

const userLog = (user: User | null) =>
	user
		? blue(user.username) + " ".repeat(21 - user.username.length)
		: yellow("Logged-out user      ")

async function finish({ event, resolve }: Parameters<Handle>[0]) {
	const { pathname, search } = event.url
	const { user } = event.locals

	if (config.Logging.Requests) {
		// Fancy logging: time(?), user, method, and path
		const { method } = event.request
		console.log(
			time(),
			userLog(user),
			methodColours[method] || method,
			" ".repeat(7 - method.length),
			pathnameColour(
				redact(readablePath(pathname)) + redactSearch(search)
			)
		)
	}

	const res = await resolve(event)
	if (!res.headers.get("content-type")?.includes("text/html")) return res

	// if it's html, add the user's theme and custom CSS before the </body> tag
	// A theme removed from the config leaves users with a stored index that no longer exists, so fall back to the first theme rather than failing every page they request
	const theme = config.Themes[user?.theme ?? 0] ?? config.Themes[0]
	const file = Bun.file(`../Assets/${theme.Path}`)
	const themecss = await file.text()
	const customcss = user?.css
		? `<style id="custom-css">${styleText(user.css)}</style>`
		: ""

	// duplicate the response to avoid modifying the original
	// A function replacement, so patterns like $& in the user's CSS are inserted as written
	const text = (await res.clone().text()).replace(
		"</body>",
		() => `<style>${themecss}</style>${customcss}</body>`
	)

	res.headers.delete("content-length") // prevent cutoff, since the body was modified

	return new Response(text, {
		headers: res.headers,
		status: res.status,
		statusText: res.statusText,
	})
}

// Ran every time a dynamic request is made.
// Requests for prerendered pages do not trigger this hook.
export async function handle(e: Parameters<Handle>[0]) {
	const { event } = e

	const token = event.cookies.get(cookieName)
	if (!token) {
		event.locals.moderated = false
		event.locals.session = null
		event.locals.user = null
		event.cookies.delete(cookieName, { path: "/" })

		return finish(e)
	}

	const { session, user } = await validateSessionToken(token)
	if (!session || !user) {
		// Stop the browser sending a token that can never work again, and keep locals matching their declared types
		event.locals.moderated = false
		event.locals.session = null
		event.locals.user = null
		event.cookies.delete(cookieName, { path: "/" })

		return finish(e)
	}

	event.locals.session = session
	event.locals.user = user
	event.cookies.set(cookieName, session, cookieOptions)

	const [, moderated] = await db.query<boolean[]>(moderatedQuery, {
		user: Record("user", user.id),
	})
	event.locals.moderated = moderated

	const { pathname } = event.url
	if (
		moderated &&
		!["/moderation", "/api"].includes(pathname) &&
		!pathname.startsWith("/api/avatar")
	)
		redirect(302, "/moderation")

	try {
		await stipend(e.event.fetch, new EconUser(user.id))
	} catch {
		console.error("Stipend failed to process")
	}

	return finish(e)
}

export function handleError({ kind, error }: Parameters<HandleServerError>[0]) {
	// Expected errors, thrown with error(), were never passed to handleError before SvelteKit 3, so they stay out of the logs
	if (kind === "app") return

	if (typeof error === "object" && error != null) {
		const { status } = error as { status?: number }
		if (status) {
			console.error(status, red(JSON.stringify(error) ?? ""))
			return
		}
	}

	// Simple error logging (not a stack trace)
	if (!config.Logging.FormattedErrors) console.error(error)
	else console.error(red(String(error)))
}
