import surreal, { query, mquery, surql } from "./surreal"
import type {
	Adapter,
	DatabaseSession,
	DatabaseUser,
	RegisteredDatabaseUserAttributes,
} from "lucia"

export class SurrealAdapter implements Adapter {
	public async deleteSession(sessionId: string): Promise<void> {
		await surreal.delete(`session:${sessionId}`)
	}

	public async deleteUserSessions(userId: string): Promise<void> {
		await query(surql`DELETE session WHERE $user ∈ <-hasSession<-user`, {
			user: `user:${userId}`,
		})
	}

	public async getSessionAndUser(
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

		return [
			session,
			user
				? {
						id: user.id,
						attributes: user,
				  }
				: null,
		]
	}

	public async getUserSessions(userId: string): Promise<DatabaseSession[]> {
		return await query<DatabaseSession>(
			surql`SELECT *, meta::id(id) AS id FROM session WHERE $user ∈ <-usingKey<-user`,
			{ user: `user:${userId}` }
		)
	}

	public async setSession(session: DatabaseSession): Promise<void> {
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

	public async updateSessionExpiration(
		sessionId: string,
		expiresAt: Date
	): Promise<void> {
		await query(surql`UPDATE $sess SET expiresAt = $expiresAt`, {
			sess: `session:${sessionId}`,
			expiresAt: Math.floor(expiresAt.getTime() / 1000),
		})
	}

	public async deleteExpiredSessions(): Promise<void> {
		await query(surql`DELETE session WHERE expiresAt < time::millis()`)
	}
}
