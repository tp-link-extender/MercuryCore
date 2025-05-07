import { authorise } from "$lib/server/auth"
import { Record, db } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import commentQuery from "./comment.surql"
import { superValidate } from "sveltekit-superforms"
import { zod } from "sveltekit-superforms/adapters"
import { z } from "zod"

const schema = z.object({
	content: z.string().min(1).max(1000),
	replyId: z.string().optional(),
})

type Comment = {
	id: string
	author: BasicUser
	content: {
		text: string
		updated: Date
	}[]
	created: Date
	dislikes: boolean
	likes: boolean
	pinned: boolean
	replies: []
	score: number
	type: string[]
	visibility: string
}


export async function load({ locals, params }) {
	const { user } = await authorise(locals)

	const [[comment]] = await db.query<Comment[][]>(commentQuery, {
		comment: Record("comment", params.comment),
		user: Record("user", user.id),
	})
	if (!comment) error(404, "Comment not found")

	return {
		comment,
		form:  await superValidate(zod(schema))
	}
}
