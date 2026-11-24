import { dbQuery } from "#lib/server/db/query.ts"
import type { RecordId } from "#lib/server/surreal.ts"
import dislikeQuery from "./likes/dislike.surql"
import likeQuery from "./likes/like.surql"
import undislikeQuery from "./likes/undislike.surql"
import unlikeQuery from "./likes/unlike.surql"

const things = Object.freeze(["asset", "comment", "place"] as const)
const queries = Object.freeze({
	dislike: unlikeQuery + dislikeQuery,
	like: undislikeQuery + likeQuery,
	undislike: undislikeQuery,
	unlike: unlikeQuery,
} as const)
const actions = Object.freeze([
	"dislike",
	"like",
	"undislike",
	"unlike",
] as const)

/**
 * Likes, dislikes, or clears a like or dislike on an asset, comment or place.
 * Liking removes a dislike, and disliking removes a like.
 */
export async function likeThing(
	user: RecordId<"user">,
	thing: RecordId<(typeof things)[number]>,
	action: (typeof actions)[number]
): Promise<void> {
	await dbQuery(queries[action], { thing, user })
}
