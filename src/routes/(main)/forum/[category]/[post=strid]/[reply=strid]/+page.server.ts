import { actions } from "../+page.server"
import { authorise } from "$lib/server/lucia"
import { RecordId, equery, surql, surrealql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import { recurse, type Replies } from "$lib/server/nestedReplies"
import forumRepliesQuery from "./reply.surql"

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

export async function load({ locals, params }) {
	const { user } = await authorise(locals)

	const [[post]] = await equery<{ author: { username: string } }[][]>(
		surrealql`
			SELECT
				(SELECT username FROM <-posted<-user)[0] AS author
			FROM ${new RecordId("forumPost", params.post)}`
	)

	if (!post) error(404, "Post not found")

	const [forumReplies] = await equery<ForumReplies[][]>(
		forumRepliesQuery.replace("_SELECTREPLIES", SELECTREPLIES),
		{
			forumReply: `forumReply:${params.reply}`,
			forumPost: `forumPost:${params.post}`,
			user: new RecordId("user", user.id),
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
