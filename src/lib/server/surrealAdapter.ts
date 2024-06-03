import type {
	Adapter,
	DatabaseSession,
	DatabaseUser,
	RegisteredDatabaseUserAttributes,
} from "lucia"
import { RecordId, equery, surrealql } from "./surreal"

async function deleteSession(sessionId: string) {
	await equery(surrealql`DELETE $sess`, {
		sess: new RecordId("session", sessionId),
	})
}

async function deleteUserSessions(userId: string) {
	await equery(
		surrealql`DELETE session WHERE ${new RecordId(
			"user",
			userId
		)} IN <-hasSession<-user`
	)
}

async function getSessionAndUser(
	sessionId: string
): Promise<[session: DatabaseSession | null, user: DatabaseUser | null]> {
	const [session, user] = await equery<
		[DatabaseSession | null, RegisteredDatabaseUserAttributes | null]
	>(
		surrealql`
			(SELECT *, meta::id(id) AS id FROM $sess)[0];
			(SELECT *, meta::id(id) AS id FROM $sess<-hasSession<-user)[0]`,
		{ sess: new RecordId("session", sessionId) }
	)

	if (session)
		session.expiresAt = new Date(
			(session.expiresAt as unknown as number) * 1000
		)

	return [session, user ? { id: user.id, attributes: user } : null]
}

async function setSession(session: DatabaseSession) {
	await equery(
		surrealql`
			LET $s = CREATE $sess SET expiresAt = time::unix($expiresAt);
			RELATE $user->hasSession->$s`,
		{
			sess: new RecordId("session", session.id),
			...session,
			user: new RecordId("user", session.userId),
		}
	)
}

async function updateSessionExpiration(
	sessionId: string,
	expiresAt: Date
): Promise<void> {
	await equery(surrealql`UPDATE $sess SET expiresAt = $expiresAt`, {
		sess: new RecordId("session", sessionId),
		expiresAt: Math.floor(expiresAt.getTime() / 1000),
	})
}

async function deleteExpiredSessions(): Promise<void> {
	await equery(surrealql`DELETE session WHERE expiresAt < time::millis()`)
}

async function getUserSessions(userId: string) {
	const result = await equery<DatabaseSession[][]>(
		surrealql`
			SELECT *, meta::id(id) AS id FROM session
			WHERE $user IN <-usingKey<-user`,
		{ user: new RecordId("user", userId) }
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
