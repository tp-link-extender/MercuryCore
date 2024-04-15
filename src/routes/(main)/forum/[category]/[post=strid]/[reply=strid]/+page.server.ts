import { actions } from "../+page.server"
import { authorise } from "$lib/server/lucia"
import { query, squery, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import { recurse, type Replies } from "$lib/server/nestedReplies"

const SELECTREPLIES = recurse(
	from => surql`(${from} <-replyToReply<-forumReply) AS replies`,
	"replyToReply",
	"forumReply",
	8
)

type ForumReplies = Replies[number] & {
	parentPost: {
		title: string
		id: string
		forumCategoryName: string
	}
}

const forumRepliesQuery = (await import("./reply.surql")).default

export async function load({ locals, params }) {
	const post = await squery<{
		author: {
			username: string
		}
	}>(
		surql`
			SELECT
				(SELECT username FROM <-posted<-user)[0] AS author
			FROM $forumPost`,
		{ forumPost: `forumPost:${params.post}` }
	)

	if (!post) error(404, "Post not found")

	const { user } = await authorise(locals)

	const forumReplies = await query<ForumReplies>(
		forumRepliesQuery.replace("_SELECTREPLIES", SELECTREPLIES),
		{
			forumReply: `forumReply:${params.reply}`,
			forumPost: `forumPost:${params.post}`,
			user: `user:${user.id}`,
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
