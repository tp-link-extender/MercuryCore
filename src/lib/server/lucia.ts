// Initialising Lucia, the authentication library

import { dev } from "$app/environment"
import { prisma } from "$lib/server/prisma"
import { redirect, error } from "@sveltejs/kit"
import { createClient } from "redis"
import { lucia } from "lucia"
import type { Session, User } from "lucia"
import { sveltekit } from "lucia/middleware"
import { prisma as prismaAdapter } from "@lucia-auth/adapter-prisma"
import { redis as redisAdapter } from "@lucia-auth/adapter-session-redis"

const prismaClient = prisma
const redisClient = createClient({ url: "redis://localhost:6479" })
redisClient.connect()

export const auth = lucia({
	middleware: sveltekit(),
	adapter: {
		user: prismaAdapter(prismaClient, {
			user: "authUser",
			key: "authKey",
			session: "authKey", // fuck you
		}),
		session: redisAdapter(redisClient),
	},
	env: dev ? "DEV" : "PROD",
	getUserAttributes: data => ({
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
})

export type Auth = typeof auth

/**
 * Authorises a user and returns their session and user data, or redirects them to the login page.
 * @param locals the locals object, containing the validate function that returns data about the user.
 * @param level The permission level that is required.
 * @returns An object containing the session and user data. If the authorisation fails, it will throw a redirect to /login.
 * @example
 * const { session, user } = await authorise(locals)
 */
export async function authorise(
	{
		auth,
	}: {
		auth: {
			validate: () => Promise<Session | null>
		}
	},
	level?: number,
) {
	const session = await auth.validate()
	const user = session?.user

	if (!session || !user) throw redirect(302, "/login")
	if (level && user.permissionLevel < level)
		throw error(403, "You do not have permission to view this page.")
	return { session, user }
}
