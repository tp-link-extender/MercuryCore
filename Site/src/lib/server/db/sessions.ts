import { dbQuery } from "#lib/server/db/query.ts"
import { Record, type RecordId } from "#lib/server/surreal.ts"
import createQuery from "./sessions/create.surql"
import deleteQuery from "./sessions/delete.surql"
import deleteUserQuery from "./sessions/deleteUser.surql"
import moderatedQuery from "./sessions/moderated.surql"
import validateQuery from "./sessions/validate.surql"

type SessionValidationResult =
	| { session: string; user: SessionUser }
	| { session: null; user: null }

/**
 * Starts a session for a user.
 * @returns The session token, which is stored in the user's cookie.
 */
export async function createSession(user: RecordId<"user">): Promise<string> {
	const [, session] = await dbQuery<string[]>(createQuery, { user })
	return session
}

/**
 * Checks a session token, extending it if it's close to expiring.
 * @returns The session and the user it belongs to, or nulls if the session is missing or expired.
 */
export async function validateSession(
	token: string
): Promise<SessionValidationResult> {
	// The last statement's result is the session and user
	const results = await dbQuery<SessionValidationResult[]>(validateQuery, {
		sess: Record("session", token),
	})
	const res = results.at(-1)
	if (!res?.session || !res.user) return { session: null, user: null }
	return res
}

export async function invalidateSession(sessionId: string): Promise<void> {
	await dbQuery(deleteQuery, { sess: Record("session", sessionId) })
}

export async function invalidateAllSessions(user: string): Promise<void> {
	await dbQuery(deleteUserQuery, { user: Record("user", user) })
}

/**
 * Records that a user was seen, and finds whether they have an active moderation.
 * @returns Whether the user is moderated.
 */
export async function recordSeenAndCheckModeration(
	user: string
): Promise<boolean> {
	const [, moderated] = await dbQuery<boolean[]>(moderatedQuery, {
		user: Record("user", user),
	})
	return moderated
}
