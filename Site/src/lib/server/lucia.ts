// Initialising Lucia, the authentication library

import { dev } from "$app/environment"
import config from "$lib/server/config"
import { SurrealAdapter } from "$lib/server/surrealAdapter"
import { error, redirect } from "@sveltejs/kit"
import { Lucia, type Session, type User } from "lucia"

// As of v3, Lucia no longer shits itself if it doesn't have access to the database clients during build time
export const auth = new Lucia(new SurrealAdapter(), {
	sessionCookie: { attributes: { secure: !dev } },
	getUserAttributes: data => ({
		// This is the data that will be available in data.user in a +page.svelte or +layout.svelte file, or authorise() in a +page.server.ts or +layout.server.ts file.
		id: data.id,
		bio: data.bio,
		email: data.email ? `*******@${data.email.split("@")[1]}` : undefined,
		username: data.username,
		status: data.status,
		permissionLevel: data.permissionLevel,
		accountCreated: data.created,
		bodyColours: data.bodyColours,
		css: data.css,
		theme: data.theme < config.Themes.length ? data.theme : 0,
		// Types for this are defined in src/app.d.ts.
	}),
})

/**
 * Authorises a user and returns their session and user data, or redirects them to the login page.
 * @param locals the locals object, containing the user and their session.
 * @param level The permission level that is required.
 * @returns An object containing the session and user data. If the authorisation fails, it will redirect the user to /login.
 * @example
 * const { session, user } = await authorise(locals)
 */
export async function authorise(
	{ user, session }: { user: User | null; session: Session | null },
	level?: number
) {
	if (!session || !user) redirect(302, "/login")
	if (level && user.permissionLevel < level)
		error(403, "You do not have permission to access this page.")

	return { session, user }
}
