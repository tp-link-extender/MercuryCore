import { authorise } from "$lib/server/auth"
import { Record, db } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
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

export async function POST({ locals, params, request }) {
	const { user } = await authorise(locals)

	const data = await request.formData()

	const action = data.get("action") as (typeof actions)[number]
	if (!action) error(400, "Missing action")
	if (!actions.includes(action)) error(400, "Invalid action")

	const { thing, id } = params
	const t = thing as (typeof things)[number]
	if (!things.includes(t)) error(400, "Invalid thing")

	const thingId = t === "place" ? +id : id
	const qParams = {
		user: Record("user", user.id),
		thing: Record(t, thingId),
	}

	await db.query(queries[action], qParams)

	return new Response()
}
