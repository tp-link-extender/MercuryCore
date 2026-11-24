import { authorise } from "#lib/server/auth.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import { Record } from "#lib/server/surreal.ts"
import type { PageServerLoadEvent } from "./$types"
import homeQuery from "./home.surql"

interface Place {
	dislikeCount: number
	id: number
	likeCount: number
	name: string
	playerCount: number
	serverPing: number
}

interface Status {
	author: BasicUser
	created: Date
	currentContent: string
	id: string
	pinned: boolean
	replies: number
	visibility: "Visible" | "Moderated" | "Deleted"
}

// lazy eval 💞
const greets: readonly ((u: string) => string)[] = Object.freeze([
	u => `Hi, ${u}!`,
	u => `Hello, ${u}!`,
])

export async function load({ locals }: PageServerLoadEvent) {
	const { user } = await authorise(locals)
	// (main)/+layout.server.ts will handle most redirects for logged-out users, but sometimes errors for this page.

	const [places, friends, feed] = await dbQuery<
		[Place[], BasicUser[], Status[]]
	>(homeQuery, { user: Record("user", user.id) })

	return {
		feed,
		friends,
		greet: greets[Math.floor(Math.random() * greets.length)](user.username),
		places,
	}
}
