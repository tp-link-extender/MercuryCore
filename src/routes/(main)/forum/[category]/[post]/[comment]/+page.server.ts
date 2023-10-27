import { actions } from "../+page.server"
import { authorise } from "$lib/server/lucia"
import { query, squery, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import { recurse, type Replies } from "../select"

const SELECTREPLIES = recurse(
	from => surql`(${from} <-replyToReply<-forumReply) AS replies`,
)

export async function load({ locals, params }) {
	if (!/^[0-9a-z]+$/.test(params.post)) throw error(400, "Invalid post id")

	const post = await squery<{
		author: {
			username: string
		}
	}>(
		surql`
			SELECT
				(SELECT username
				FROM <-posted<-user)[0] AS author
			FROM $forumPost`,
		{ forumPost: `forumPost:${params.post}` },
	)

	if (!post) throw error(404, "Post not found")

	const { user } = await authorise(locals)

	const forumReplies = await query<
		Replies[number] & {
			parentPost: {
				title: string
				id: string
				forumCategoryName: string
			}
		}
	>(
		surql`
			SELECT
				*,
				(SELECT text, updated FROM $parent.content
				ORDER BY updated DESC) AS content,
				meta::id(id) AS id,
				$forumPost AS parentPost,
				(IF ->replyToReply->forumReply.id THEN
					meta::id(->replyToReply[0]->forumReply[0].id)
				END) AS parentReplyId,
				(SELECT number, username FROM <-posted<-user)[0] AS author,

				count(<-likes) AS likeCount,
				count(<-dislikes) AS dislikeCount,
				$user ∈ <-likes<-user.id AS likes,
				$user ∈ <-dislikes<-user.id AS dislikes,

				(SELECT
					title,
					meta::id(id) AS id,
					->in[0]->forumCategory[0].name as forumCategoryName
				FROM $forumPost)[0] AS parentPost,

				${SELECTREPLIES}
			FROM $forumReply`,
		{
			forumReply: `forumReply:${params.comment}`,
			forumPost: `forumPost:${params.post}`,
			user: `user:${user.id}`,
		},
	)

	if (!forumReplies[0]) throw error(404, "Reply not found")

	return {
		replies: forumReplies,
		forumCategory: params.category,
		postId: params.post,
		author: post.author.username,
	}
}

export { actions }
