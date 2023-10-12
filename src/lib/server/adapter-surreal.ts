import surql from "$lib/surrealtag"
import surreal, { squery } from "$lib/server/surreal"
import type {
	Adapter,
	InitializeAdapter,
	KeySchema,
	SessionSchema,
	UserSchema,
} from "lucia"

export const adapter = (
	modelNames = {
		user: "user",
		session: "session",
		key: "key",
	},
): InitializeAdapter<Adapter> => {
	return LuciaError => {
		return {
			getUser: async userId =>
				(
					(await squery(
						surql`
							SELECT *
							FROM $id`,
						{ id: `${modelNames.user}:${userId}` },
					)) as [UserSchema]
				)[0],
			setUser: async (user, key) => {
				if (!key) {
					await squery(
						surql`
							LET $u = CREATE user CONTENT $user;
							UPDATE $u.id MERGE {
								number: (UPDATE ONLY stuff:increment SET user += 1).user,
								theme: "standard",
								created: time::now(),
								bio: [],
								bodyColours: {
									Head: 24,
									Torso: 23,
									LeftArm: 24,
									RightArm: 24,
									LeftLeg: 119,
									RightLeg: 119,
								},
							}`,
						{ user },
					)

					return
				}
				const keyExists = (
					await surreal.select(`${modelNames.key}:${key.id}`)
				)[0]

				if (keyExists) throw new LuciaError("AUTH_DUPLICATE_KEY_ID")

				await squery(
					surql`
						LET $u = CREATE user CONTENT $user;
						LET $k = CREATE $key CONTENT {
							hashed_password: $hashed_password,
						};
						RELATE $u->hasKey->$k`,
					{
						user,
						key: `${modelNames.key}:${key.id}`,
						...key,
					},
				)
			},
			deleteUser: async userId => {},
			updateUser: async (userId, partialUser) => {
				await squery(surql`UPDATE $user MERGE $partialUser`, {
					user: `${modelNames.user}:${userId}`,
					partialUser,
				})
			},
			getSession: async sessionId =>
				(
					(await surreal.select(
						`${modelNames.session}:${sessionId}`,
					)) as SessionSchema[]
				)[0],
			getSessionsByUserId: userId =>
				squery(
					surql`
						SELECT * FROM $id
						WHERE $user ∈ <-usingKey<-user`,
					{ id: `${modelNames.session}:${userId}` },
				) as Promise<SessionSchema[]>,
			setSession: async session => {
				const userExists = (
					(await squery(surql`SELECT * FROM $id`, {
						id: `${modelNames.user}:${session.user_id}`,
					})) as [{}]
				)[0]

				if (!userExists) throw new LuciaError("AUTH_INVALID_USER_ID")

				await squery(
					surql`
						LET $s = CREATE $sess CONTENT {
							active_expires: $active_expires,
							idle_expires: $idle_expires,
						};
						RELATE $user->hasSession->$s`,
					{
						sess: `${modelNames.session}:${session.id}`,
						...session,
						user: `${modelNames.user}:${session.user_id}`,
					},
				)
			},
			deleteSession: async sessionId => {
				await surreal.delete(`${modelNames.session}:${sessionId}`)
			},
			deleteSessionsByUserId: async userId => {
				await squery(
					surql`DELETE session WHERE $user ∈ <-hasSession<-user`,
					{ user: `${modelNames.user}:${userId}` },
				)
			},
			updateSession: async (userId, partialSession) => {
				delete partialSession.id
				delete partialSession.user_id

				await squery(
					surql`
						UPDATE session MERGE $partialSession
						WHERE $user ∈ <-hasSession<-user`,
					{
						user: `${modelNames.user}:${userId}`,
						partialSession,
					},
				)
			},

			getKey: async keyId =>
				(
					(await surreal.select(
						`${modelNames.key}:${keyId}`,
					)) as KeySchema[]
				)[0],
			getKeysByUserId: async userId =>
				(await squery(
					surql`
						SELECT * FROM ${modelNames.key}
						WHERE $user ∈ <-usingKey<-user`,
					{ user: `${modelNames.user}:${userId}` },
				)) as [KeySchema],
			setKey: async key => {
				const userExists = (
					(await squery(surql`SELECT * FROM $id`, {
						id: `${modelNames.user}:${key.user_id}`,
					})) as [{}]
				)[0]

				if (!userExists) throw new LuciaError("AUTH_INVALID_USER_ID")

				const keyExists = (
					await surreal.select(`${modelNames.key}:${key.id}`)
				)[0]

				if (keyExists) throw new LuciaError("AUTH_DUPLICATE_KEY_ID")

				await squery(
					surql`
						LET $k = CREATE $key CONTENT {
							hashed_password: $hashed_password,
						};
						RELATE $user->hasKey->$k`,
					{
						key: `${modelNames.key}:${key.id}`,
						...key,
						user: `${modelNames.user}:${key.user_id}`,
					},
				)
			},
			deleteKey: async keyId => {
				await surreal.delete(`${modelNames.key}:${keyId}`)
			},
			deleteKeysByUserId: async userId => {
				await squery(surql`DELETE key WHERE $user ∈ <-hasKey<-user`, {
					user: `${modelNames.user}:${userId}`,
				})
			},
			updateKey: async (keyId, partialKey) => {
				await squery(
					surql`UPDATE $key SET hashed_password = $hashed_password`,
					{
						key: `${modelNames.key}:${keyId}`,
						...partialKey,
					},
				)
			},
		}
	}
}
