import { query, mquery, surql } from "./surreal"
import type {
	Adapter,
	DatabaseSession,
	DatabaseUser,
	RegisteredDatabaseUserAttributes,
} from "lucia"

async function deleteSession(sessionId: string) {
	await query(surql`DELETE $sess`, { sess: `session:${sessionId}` })
}

async function deleteUserSessions(userId: string) {
	await query(surql`DELETE session WHERE $user IN <-hasSession<-user`, {
		user: `user:${userId}`,
	})
}

async function getSessionAndUser(
	sessionId: string
): Promise<[session: DatabaseSession | null, user: DatabaseUser | null]> {
	const [session, user] = await mquery<
		[DatabaseSession | null, RegisteredDatabaseUserAttributes | null]
	>(
		surql`
			(SELECT *, meta::id(id) AS id FROM $sess)[0];
			(SELECT *, meta::id(id) AS id FROM $sess<-hasSession<-user)[0]`,
		{ sess: `session:${sessionId}` }
	)

	if (session)
		session.expiresAt = new Date(
			(session.expiresAt as unknown as number) * 1000
		)

	return [session, user ? { id: user.id, attributes: user } : null]
}

async function setSession(session: DatabaseSession) {
	await query(
		surql`
			LET $s = CREATE $sess SET expiresAt = time::unix($expiresAt);
			RELATE $user->hasSession->$s`,
		{
			sess: `session:${session.id}`,
			...session,
			user: `user:${session.userId}`,
		}
	)
}

async function updateSessionExpiration(
	sessionId: string,
	expiresAt: Date
): Promise<void> {
	await query(surql`UPDATE $sess SET expiresAt = $expiresAt`, {
		sess: `session:${sessionId}`,
		expiresAt: Math.floor(expiresAt.getTime() / 1000),
	})
}

async function deleteExpiredSessions(): Promise<void> {
	await query(surql`DELETE session WHERE expiresAt < time::millis()`)
}

async function getUserSessions(userId: string) {
	return await query<DatabaseSession>(
		surql`
			SELECT *, meta::id(id) AS id FROM session
			WHERE $user IN <-usingKey<-user`,
		{ user: `user:${userId}` }
	)
}
export class SurrealAdapter implements Adapter {
	public deleteSession = deleteSession
	public deleteUserSessions = deleteUserSessions
	public getSessionAndUser = getSessionAndUser
	public getUserSessions = getUserSessions
	public setSession = setSession
	public updateSessionExpiration = updateSessionExpiration
	public deleteExpiredSessions = deleteExpiredSessions
}
