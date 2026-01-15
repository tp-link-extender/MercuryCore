import { db, type RecordId } from "$lib/server/surreal"
import dislikeQuery from "./dislike.surql"
import likeQuery from "./like.surql"
import undislikeQuery from "./undislike.surql"
import unlikeQuery from "./unlike.surql"

const things = Object.freeze(["asset", "comment", "place"] as const)
const queries = Object.freeze({
	dislike: unlikeQuery + dislikeQuery,
	like: undislikeQuery + likeQuery,
	undislike: undislikeQuery,
	unlike: unlikeQuery,
} as const)
const actions = Object.keys(queries) as (keyof typeof queries)[]

export default (
	user: RecordId<"user">,
	thing: RecordId<(typeof things)[number]>,
	action: (typeof actions)[number]
) => db.query(queries[action], { user, thing })
