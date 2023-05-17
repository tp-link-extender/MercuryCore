// Initialising Lucia, the authentication library

import { dev } from "$app/environment"
import { prisma } from "$lib/server/prisma"
import { redirect, error } from "@sveltejs/kit"
import { createClient } from "redis"
import lucia from "lucia-auth"
import type { Session, User } from "lucia-auth"
import { sveltekit } from "lucia-auth/middleware"
import prismaAdapter from "@lucia-auth/adapter-prisma"
import redisAdapter from "@lucia-auth/adapter-session-redis"

const prismaClient = prisma
const session = createClient({ url: "redis://localhost:6479" })
const userSession = createClient({ url: "redis://localhost:6479" })
session.connect()
userSession.connect()

export const auth = lucia({
	middleware: sveltekit(),
	adapter: {
		user: prismaAdapter(prismaClient as any),
		session: redisAdapter({
			session,
			userSession,
		}),
	},
	env: dev ? "DEV" : "PROD",
	transformDatabaseUser: data => ({
		// This is the data that will be available after calling getUser()
		// in a +page.svelte or +layout.svelte file, or authorise() in a
		// +page.server.ts or +layout.server.ts file.
		id: data.id,
		number: data.number,
		bio: data.bio,
		email: data.email,
		username: data.username,
		currency: data.currency,
		currencyCollected: data.currencyCollected,
		permissionLevel: data.permissionLevel,
		accountCreated: data.created,
		bodyColours: data.bodyColours,
		theme: data.theme,
		// Types for this are defined in src/app.d.ts.
	}),
	generateCustomUserId: () => crypto.randomUUID(),
})

export type Auth = typeof auth

/**
 * Authorises a user and returns their session and user data, or redirects them to the login page.
 * @param locals the locals object, containing the validateUser function that returns data about the user.
 * @param level The permission level that is required.
 * @returns An object containing the session and user data. If the authorisation fails, it will throw a redirect to /login.
 * @example
 * const { session, user } = await authorise(locals)
 */
export async function authorise(
	{
		validateUser,
	}: {
		validateUser: () => Promise<
			| {
					session: Session
					user: User
			  }
			| {
					session: null
					user: null
			  }
		>
	},
	level?: number
) {
	const { session, user } = await validateUser()
	if (!session) throw redirect(302, "/login")
	if (level && user.permissionLevel < level)
		throw error(403, "You do not have permission to view this page.")
	return { session, user }
}
