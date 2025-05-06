import { authorise } from "$lib/server/auth"
import exclude from "$lib/server/exclude"
import type { Replies } from "$lib/server/nestedReplies"
import { Record, db } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import postQuery from "./post.surql"
import repliesQuery from "./replies.surql"

type ForumReplies = Replies[number] & {
	parentPost: {
		title: string
		id: string
		forumCategoryName: string
	}
}

export async function load({ locals, params }) {
	exclude("Forum")
	const { user } = await authorise(locals)

	const [[post]] = await db.query<{ author: { username: string } }[][]>(
		postQuery,
		{ forumPost: Record("forumPost", params.post) }
	)
	if (!post) error(404, "Post not found")

	const [forumReplies] = await db.query<ForumReplies[][]>(repliesQuery, {
		forumReply: Record("forumReply", params.reply),
		forumPost: Record("forumPost", params.post),
		user: Record("user", user.id),
	})
	if (!forumReplies[0]) error(404, "Reply not found")

	return {
		replies: forumReplies,
		forumCategory: params.category,
		postId: params.post,
		author: post.author.username,
	}
}

export { actions } from "../+page.server"
