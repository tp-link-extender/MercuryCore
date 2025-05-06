// we've come full circle, from lucia-sveltekit 0.3 to 0.1 to Lucia 0.3 to 1.0 to 2.0 to 3.2 to now.

import { dev } from "$app/environment"
import { Record, db } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"
import deleteExpiredSessionsQuery from "./deleteExpiredSessions.surql"
import deleteUserSessionsQuery from "./deleteUserSessions.surql"
import getSessionAndUserQuery from "./getSessionAndUser.surql"
import setSessionQuery from "./setSession.surql"

export async function createSession(user: string): Promise<Session> {
	const session = await db.query<Session[]>(setSessionQuery, {
		user: Record("user", user),
	})

	return session[2]
}

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
	await db.query(deleteExpiredSessionsQuery, {
		sess: Record("session", sessionId),
	})
}

export async function invalidateAllSessions(user: string): Promise<void> {
	await db.query(deleteUserSessionsQuery, {
		user: Record("user", user),
	})
}

export type SessionValidationResult =
	| { session: Session; user: User }
	| { session: null; user: null }

export const cookieName = "session"
export const cookieOptions = Object.freeze({
	httpOnly: true,
	sameSite: "lax",
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
	{ user, session }: { user: User | null; session: Session | null },
	level?: number
) {
	if (!session || !user) redirect(302, "/login")
	if (level && user.permissionLevel < level)
		error(403, "You do not have permission to access this page.")

	return { session, user }
}
