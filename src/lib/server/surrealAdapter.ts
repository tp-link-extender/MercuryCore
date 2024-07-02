import type {
	Adapter,
	DatabaseSession,
	DatabaseUser,
	RegisteredDatabaseUserAttributes,
} from "lucia"
import { Record, equery, surql } from "./surreal.ts"

async function deleteSession(sessionId: string) {
	await equery(surql`DELETE ${Record("session", sessionId)}`)
}

async function deleteUserSessions(userId: string) {
	await equery(surql`DELETE session WHERE $user IN <-hasSession<-user`, {
		user: Record("user", userId),
	})
}

async function getSessionAndUser(
	sessionId: string
): Promise<[session: DatabaseSession | null, user: DatabaseUser | null]> {
	const [session, user] = await equery<
		[DatabaseSession | null, RegisteredDatabaseUserAttributes | null]
	>(
		surql`
			(SELECT *, meta::id(id) AS id FROM $sess)[0];
			(SELECT *, meta::id(id) AS id FROM $sess<-hasSession<-user)[0]`,
		{ sess: Record("session", sessionId) }
	)

	if (session)
		session.expiresAt = new Date(
			(session.expiresAt as unknown as number) * 1000
		)

	return [session, user ? { id: user.id, attributes: user } : null]
}

async function setSession(session: DatabaseSession) {
	await equery(
		surql`
			LET $s = CREATE ${Record("session", session.id)}
				SET expiresAt = time::unix($expiresAt);
			RELATE $user->hasSession->$s`,
		{ ...session, user: Record("user", session.userId) }
	)
}

async function updateSessionExpiration(
	sessionId: string,
	expiresAt: Date
): Promise<void> {
	await equery(
		surql`
			UPDATE ${Record("session", sessionId)}
			SET expiresAt = ${Math.floor(expiresAt.getTime() / 1000)}`
	)
}

async function deleteExpiredSessions(): Promise<void> {
	await equery(surql`DELETE session WHERE expiresAt < time::millis()`)
}

async function getUserSessions(userId: string) {
	const result = await equery<DatabaseSession[][]>(
		surql`
			SELECT *, meta::id(id) AS id FROM session
			WHERE ${Record("user", userId)} IN <-usingKey<-user`
	)
	return result[0]
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