import { authorise } from "#lib/server/auth.ts"
import { homeOf } from "#lib/server/db/feed.ts"
import { Record } from "#lib/server/surreal.ts"
import type { PageServerLoadEvent } from "./$types"

// lazy eval 💞
const greets: readonly ((u: string) => string)[] = Object.freeze([
	u => `Hi, ${u}!`,
	u => `Hello, ${u}!`,
])

export async function load({ locals }: PageServerLoadEvent) {
	const { user } = await authorise(locals)
	// (main)/+layout.server.ts will handle most redirects for logged-out users, but sometimes errors for this page.

	const { feed, friends, places } = await homeOf(Record("user", user.id))

	return {
		feed,
		friends,
		greet: greets[Math.floor(Math.random() * greets.length)](user.username),
		places,
	}
}
