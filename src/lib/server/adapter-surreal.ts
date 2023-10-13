import surql from "$lib/surrealtag"
import surreal, { query } from "$lib/server/surreal"
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
					await query<UserSchema>(
						surql`
							SELECT
								*,
								meta::id(id) AS id
							FROM $id`,
						{ id: `${modelNames.user}:${userId}` },
					)
				)[0],
			setUser: async (user, key) => {
				// Can't create the user number in the MERGE step, or it would
				// create two numbers (why?) and miss out all the odd ones
				const createUser = surql`
					LET $u = CREATE user CONTENT $user;
					UPDATE $u MERGE {
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
					};
					UPDATE $u SET number =
						(UPDATE ONLY stuff:increment
						SET user += 1).user`

				if (!key) {
					await query(createUser, { user })
					return
				}

				const keyExists = (
					await surreal.select(`${modelNames.key}:⟨${key.id}⟩`)
				)[0]

				if (keyExists) throw new LuciaError("AUTH_DUPLICATE_KEY_ID")

				await query(
					surql`
						${createUser};
						LET $k = CREATE $key CONTENT {
							hashed_password: $hashed_password,
						};
						RELATE $u->hasKey->$k`,
					{
						user,
						key: `${modelNames.key}:⟨${key.id}⟩`,
						...key,
					},
				)
			},
			deleteUser: async userId => {},
			updateUser: async (userId, partialUser) => {
				await query(surql`UPDATE $user MERGE $partialUser`, {
					user: `${modelNames.user}:${userId}`,
					partialUser,
				})
			},
			getSession: async sessionId =>
				(
					await query<SessionSchema>(
						surql`
							SELECT
								*,
								meta::id((<-hasSession<-user)[0]) AS user_id,
								meta::id(id) AS id
							FROM $sess`,
						{ sess: `${modelNames.session}:${sessionId}` },
					)
				)[0],
			getSessionsByUserId: userId =>
				query<SessionSchema>(
					surql`
						SELECT * FROM $id
						WHERE $user ∈ <-usingKey<-user`,
					{ id: `${modelNames.session}:${userId}` },
				),
			setSession: async session => {
				const userExists = (
					await query(surql`SELECT true FROM $id`, {
						id: `${modelNames.user}:${session.user_id}`,
					})
				)[0]

				if (!userExists) throw new LuciaError("AUTH_INVALID_USER_ID")

				await query(
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
				await query(
					surql`DELETE session WHERE $user ∈ <-hasSession<-user`,
					{ user: `${modelNames.user}:${userId}` },
				)
			},
			updateSession: async (userId, partialSession) => {
				delete partialSession.id
				delete partialSession.user_id

				await query(
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
					await query<KeySchema>(
						surql`
							SELECT
								*,
								meta::id((<-hasKey<-user)[0]) AS user_id,
								meta::id(id) AS id
							FROM $key`,
						{ key: `${modelNames.key}:⟨${keyId}⟩` },
					)
				)[0],
			getKeysByUserId: async userId => {
				return await query<KeySchema>(
					surql`
						SELECT * FROM ${modelNames.key}
						WHERE $user ∈ <-usingKey<-user`,
					{ user: `${modelNames.user}:${userId}` },
				)
			},
			setKey: async key => {
				const userExists = (
					await query(surql`SELECT true FROM $id`, {
						id: `${modelNames.user}:${key.user_id}`,
					})
				)[0]

				if (!userExists) throw new LuciaError("AUTH_INVALID_USER_ID")

				const keyExists = (
					await surreal.select(`${modelNames.key}:⟨${key.id}⟩`)
				)[0]

				if (keyExists) throw new LuciaError("AUTH_DUPLICATE_KEY_ID")

				await query(
					surql`
						LET $k = CREATE $key CONTENT {
							hashed_password: $hashed_password,
						};
						RELATE $user->hasKey->$k`,
					{
						key: `${modelNames.key}:⟨${key.id}⟩`,
						...key,
						user: `${modelNames.user}:${key.user_id}`,
					},
				)
			},
			deleteKey: async keyId => {
				await surreal.delete(`${modelNames.key}:⟨${keyId}⟩`)
			},
			deleteKeysByUserId: async userId => {
				await query(surql`DELETE key WHERE $user ∈ <-hasKey<-user`, {
					user: `${modelNames.user}:${userId}`,
				})
			},
			updateKey: async (keyId, partialKey) => {
				await query(
					surql`UPDATE $key SET hashed_password = $hashed_password`,
					{
						key: `${modelNames.key}:⟨${keyId}⟩`,
						...partialKey,
					},
				)
			},
		}
	}
}
