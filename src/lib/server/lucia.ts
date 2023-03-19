// Initialising Lucia, the authentication library

import { dev } from "$app/environment"
import { prisma } from "$lib/server/prisma"
import { redirect, error } from "@sveltejs/kit"
import { createClient } from "redis"
import lucia from "lucia-auth"
import type { Session, User } from "lucia-auth"
import prismaAdapter from "@lucia-auth/adapter-prisma"
import redisAdapter from "@lucia-auth/adapter-session-redis"

const session = createClient({ url: "redis://localhost:6479" })
const userSession = createClient({ url: "redis://localhost:6479" })
session.connect()
userSession.connect()

export const auth = lucia({
	adapter: {
		user: prismaAdapter(prisma),
		session: redisAdapter({
			session,
			userSession,
		}),
	},
	env: dev ? "DEV" : "PROD",
	transformUserData: (data: any) => ({
		// This is the data that will be available after calling
		// getUser() in a +page.svelte or +layout.svelte file.
		userId: data.id,
		number: data.number,
		bio: data.bio,
		email: data.email,
		username: data.username,
		image: data.image,
		currency: data.currency,
		currencyCollected: data.currencyCollected,
		permissionLevel: data.permissionLevel,
		accountCreated: data.created,
		bodyColours: data.bodyColours,
		moderation: data.moderationActionsReceived,
		theme: data.theme,
		animationSettings: data.animationSettings,
	}),
	generateCustomUserId: () => crypto.randomUUID(),
})

export type Auth = typeof auth

/**
 * Authorises a user and returns their session and user data, or redirects them to the login page.
 * @param promise locals.validateUser, the function that returns data about the user.
 * @returns An object containing the session and user data. If the authorisation fails, it will throw a redirect to /login.
 * @example
 * const { session, user } = await authorise(locals.validateUser)
 */
export async function authorise(
	promise: () => Promise<
		| {
				session: Session
				user: User
		  }
		| {
				session: null
				user: null
		  }
	>
) {
	const { session, user } = await promise()
	if (!session) throw redirect(302, "/login")
	return { session, user }
}

/**
 * Authorises an administrator and returns their session and user data, or throws an error if they are not authorised.
 * @param promise locals.validateUser, the function that returns data about the user.
 * @returns An object containing the session and user data. If the authorisation fails, it will throw an error page.
 * @example
 * const { session, user } = await authoriseAdmin(locals)
 */
export async function authoriseAdmin(locals: any) {
	const { session, user } = await locals.validateUser()

	if (!session || user.permissionLevel < 5)
		throw error(
			451,
			Buffer.from("RHVtYiBuaWdnYSBkZXRlY3RlZA", "base64").toString(
				"ascii"
			)
		)
}

/**
 * Authorises a moderator and returns their session and user data, or throws an error if they are not authorised.
 * @param promise locals.validateUser, the function that returns data about the user.
 * @returns An object containing the session and user data. If the authorisation fails, it will throw an error page.
 * @example
 * const { session, user } = await authoriseMod(locals)
 */
export async function authoriseMod(locals: any) {
	const { session, user } = await locals.validateUser()

	if (!session || user.permissionLevel < 4)
		throw error(
			451,
			Buffer.from("RHVtYiBuaWdnYSBkZXRlY3RlZA", "base64").toString(
				"ascii"
			)
		)
}

/**
 * Authorises any user with permissionLevel > 2 and returns their session and user data or throws an error if they are not authorised.
 * @param promise locals.validateUser, the function that returns data about the user.
 * @returns An object containing the session and user data. If the authorisation fails, it will throw an error page.
 * @example
 * const { session, user } = await authoriseAllAdmin(locals)
 */
export async function authoriseAllAdmin(locals: any) {
	const { session, user } = await locals.validateUser()

	if (!session || user.permissionLevel < 3)
		throw error(
			451,
			Buffer.from("RHVtYiBuaWdnYSBkZXRlY3RlZA", "base64").toString(
				"ascii"
			)
		)
}
