import { authorise } from "$lib/server/lucia"
import { type Replies, recurse } from "$lib/server/nestedReplies"
import { Record, equery, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import { actions } from "../+page.server"
import forumRepliesQuery from "./reply.surql"

const SELECTREPLIES = recurse("<-replyToReply<-forumReply")

type ForumReplies = Replies[number] & {
	parentPost: {
		title: string
		id: string
		forumCategoryName: string
	}
}

export async function load({ locals, params }) {
	const { user } = await authorise(locals)

	const [[post]] = await equery<{ author: { username: string } }[][]>(
		surql`
			SELECT
				(SELECT username FROM <-posted<-user)[0] AS author
			FROM ${Record("forumPost", params.post)}`
	)

	if (!post) error(404, "Post not found")

	const [forumReplies] = await equery<ForumReplies[][]>(
		forumRepliesQuery.replace("_SELECTREPLIES", SELECTREPLIES),
		{
			forumReply: Record("forumReply", params.reply),
			forumPost: Record("forumPost", params.post),
			user: Record("user", user.id),
		}
	)

	if (!forumReplies[0]) error(404, "Reply not found")

	return {
		replies: forumReplies,
		forumCategory: params.category,
		postId: params.post,
		author: post.author.username,
	}
}

export { actions }
