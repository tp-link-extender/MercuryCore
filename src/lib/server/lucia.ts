// Initialising Lucia, the authentication library

import surql from "$lib/surrealtag"
import { dev } from "$app/environment"
import { client } from "$lib/server/redis"
import { squery } from "$lib/server/surreal"
import { PrismaClient } from "@prisma/client"
import { redirect, error } from "@sveltejs/kit"
import { lucia, type Session, type User } from "lucia"
import { sveltekit } from "lucia/middleware"
import { prisma } from "@lucia-auth/adapter-prisma"
import { redis } from "@lucia-auth/adapter-session-redis"

// As of v2, Lucia now shits itself if it doesn't have
// access to the database clients during build time
export const auth = lucia({
	middleware: sveltekit(),
	adapter: {
		user: prisma(new PrismaClient(), {
			user: "authUser",
			key: "authKey",
			session: "authKey", // fuck you
		}),
		session: redis(client),
	},
	env: dev ? "DEV" : "PROD",
	getUserAttributes: data => ({
		// This is the data that will be available in data.user
		// in a +page.svelte or +layout.svelte file, or authorise()
		// in a +page.server.ts or +layout.server.ts file.
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

export async function addUserData(user: User) {
	const surrealUser = (await squery(
		surql`
			SELECT
				*,
				bio[0].text,
				string::split(type::string(id), ":")[1] AS id
			FROM user WHERE number = $number`,
		user,
	)) as {
		bio: string
		currency: number
		email: string
		id: string
		number: number
		permissionLevel: number
		username: string
	}[]

	return {
		...user,
		...surrealUser[0],
	}
}

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
	const session = await auth.validate(),
		user = session?.user

	if (!session || !user) throw redirect(302, "/login")
	if (level && user.permissionLevel < level)
		throw error(403, "You do not have permission to view this page.")

	return {
		session,
		user: await addUserData(user),
	}
}
