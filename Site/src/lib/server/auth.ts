// we've come full circle, from lucia-sveltekit 0.3 to 0.1 to Lucia 0.3 to 1.0 to 2.0 to 3.2 to now.

import { error, redirect } from "@sveltejs/kit"
import { dev } from "$app/environment"
import deleteSessionsQuery from "$lib/server/deleteSessions.surql"
import deleteUserSessionsQuery from "$lib/server/deleteUserSessions.surql"
import getSessionAndUserQuery from "$lib/server/getSessionAndUser.surql"
import setSessionQuery from "$lib/server/setSession.surql"
import { db, Record, type RecordId } from "$lib/server/surreal"

export async function createSession(user: RecordId<"user">): Promise<string> {
	const [, session] = await db.query<string[]>(setSessionQuery, { user })
	return session
}

type SessionValidationResult =
	| { session: string; user: User }
	| { session: null; user: null }

export async function validateSessionToken(
	token: string
): Promise<SessionValidationResult> {
	const [, , , res] = await db.query<SessionValidationResult[]>(
		getSessionAndUserQuery,
		{ sess: Record("session", token) }
	)
	if (!res.session || !res.user) return { session: null, user: null }
	return res
}

export async function invalidateSession(sessionId: string): Promise<void> {
	await db.query(deleteSessionsQuery, {
		sess: Record("session", sessionId),
	})
}

export async function invalidateAllSessions(user: string): Promise<void> {
	await db.query(deleteUserSessionsQuery, {
		user: Record("user", user),
	})
}

export const cookieName = "session"
export const cookieOptions = Object.freeze({
	secure: !dev,
	maxAge: 30 * 24 * 60 * 60, // 30 days
	path: "/",
})

/**
 * Authorises a user and returns their session and user data, or redirects them to the login page.
 * @param locals the locals object, containing the user and their session.
 * @param level The permission level that is required.
 * @returns An object containing the session and user data. If the authorisation fails, it will redirect the user to /login.
 * @example
 * const { session, user } = await authorise(locals)
 */
export async function authorise(
	{ session, user }: { session: string | null; user: User | null },
	level?: number
) {	if (!session || !user)
		// TODO: get session and user from getRequestEvent() locals
		redirect(302, "/login")
	if (level && user.permissionLevel < level)
		error(403, "You do not have permission to access this page.")

	return { session, user }
}
