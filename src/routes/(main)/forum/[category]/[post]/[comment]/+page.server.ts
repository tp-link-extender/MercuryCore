import surql from "$lib/surrealtag"
import { actions } from "../+page.server"
import { authorise } from "$lib/server/lucia"
import { squery } from "$lib/server/surreal"
import { valid } from "$lib/server/id"
import { error } from "@sveltejs/kit"
import { recurse, type Replies } from "../select"

const SELECTREPLIES = recurse(
	from => surql`(${from} <-replyToReply<-forumReply) AS replies`,
)

export async function load({ locals, params }) {
	if (!valid(params.post)) throw error(400, "Invalid post id")

	const post = (
		(await squery(
			surql`
				SELECT
					(SELECT username
					FROM <-posted<-user)[0] AS author
				FROM $forumPost`,
			{ forumPost: `forumPost:${params.post}` },
		)) as {
			author: {
				username: string
			}
		}[]
	)[0]

	if (!post) throw error(404, "Post not found")

	const { user } = await authorise(locals)

	const forumReplies = (await squery(
		surql`
			SELECT
				*,
				(SELECT text, updated FROM $parent.content
				ORDER BY updated DESC) AS content,
				string::split(type::string(id), ":")[1] AS id,
				$forumPost AS parentPost,
				(IF ->replyToReply->forumReply.id THEN 
					string::split(type::string(
						->replyToReply[0]->forumReply[0].id), ":")[1]
				END) AS parentReplyId,
				(SELECT number, username FROM <-posted<-user)[0] AS author,
				
				count(<-likes) AS likeCount,
				count(<-dislikes) AS dislikeCount,
				($user ∈ <-likes<-user.id) AS likes,
				($user ∈ <-dislikes<-user.id) AS dislikes,

				(SELECT
					title,
					string::split(type::string(id), ":")[1] AS id,
					->in[0]->forumCategory[0].name as forumCategoryName
				FROM $forumPost)[0] AS parentPost,

				${SELECTREPLIES}
			FROM $forumReply`,
		{
			forumReply: `forumReply:${params.comment}`,
			forumPost: `forumPost:${params.post}`,
			user: `user:${user.id}`,
		},
	)) as Replies &
		{
			parentPost: {
				title: string
				id: string
				forumCategoryName: string
			}
		}[]

	if (!forumReplies[0]) throw error(404, "Reply not found")

	return {
		replies: forumReplies,
		forumCategory: params.category,
		postId: params.post,
		author: post.author.username,
	}
}

export { actions }
