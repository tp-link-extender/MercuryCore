import { authorise } from "$lib/server/auth"
import { db, Record } from "$lib/server/surreal"
import homeQuery from "./home.surql"

type Place = {
	id: number
	name: string
	playerCount: number
	serverPing: number
	likeCount: number
	dislikeCount: number
}

type Status = {
	id: string
	author: BasicUser
	created: Date
	pinned: boolean
	replies: number
	visibility: "Visible" | "Moderated" | "Deleted"
	currentContent: string
}

// lazy eval 💞
const greets: readonly ((u: string) => string)[] = Object.freeze([
	u => `Hi, ${u}!`,
	u => `Hello, ${u}!`,
])

export async function load({ locals }) {
	const { user } = await authorise(locals)
	// (main)/+layout.server.ts will handle most redirects for logged-out users, but sometimes errors for this page.

	const [places, friends, feed] = await db.query<
		[Place[], BasicUser[], Status[]]
	>(homeQuery, { user: Record("user", user.id) })

	return {
		greet: greets[Math.floor(Math.random() * greets.length)](user.username),
		places,
		friends,
		feed,
	}
}
