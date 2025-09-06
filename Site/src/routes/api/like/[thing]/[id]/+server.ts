import { error } from "@sveltejs/kit"
import { authorise } from "$lib/server/auth"
import { db, Record } from "$lib/server/surreal"
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

export async function POST({ locals, params, request, url }) {
	const { user } = await authorise(locals)

	const data = await request.formData()

	const action = data.get("action") as (typeof actions)[number]
	if (!action) error(400, "Missing action")
	if (!actions.includes(action)) error(400, "Invalid action")

	const { thing, id } = params
	const t = thing as (typeof things)[number]
	if (!things.includes(t)) error(400, "Invalid thing")

	if (thing === "place") {
		const [ok] = await db.query<boolean[]>(
			`
				SELECT VALUE !privateServer OR privateTicket == $ticket
				FROM ONLY $place`,
			{
				place: Record("place", id),
				ticket: url.searchParams.get("privateTicket"),
			}
		)

		if (!ok) error(404, "Not Found")
	}

	await db.query(queries[action], {
		user: Record("user", user.id),
		thing: Record(t, id),
	})

	return new Response()
}
