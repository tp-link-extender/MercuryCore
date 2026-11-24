import { dbQuery } from "#lib/server/db/query.ts"
import type { RecordId } from "#lib/server/surreal.ts"
import homeQuery from "./feed/home.surql"

export interface HomePlace {
	dislikeCount: number
	id: number
	likeCount: number
	name: string
	playerCount: number
}

export interface FeedPost {
	author: BasicUser
	created: Date
	currentContent: string
	id: string
	// not counted yet, so always 0
	replies: number
	visibility: "Visible" | "Moderated" | "Deleted"
}

/**
 * Finds what the home page shows a user: the places to join, their friends, and the status feed.
 */
export async function homeOf(user: RecordId<"user">): Promise<{
	feed: FeedPost[]
	friends: BasicUser[]
	places: HomePlace[]
}> {
	const [places, friends, feed] = await dbQuery<
		[HomePlace[], BasicUser[], FeedPost[]]
	>(homeQuery, { user })
	return { feed, friends, places }
}
