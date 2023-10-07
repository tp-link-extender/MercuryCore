import surql from "$lib/surrealtag"
import { actions } from "../+page.server"
import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { squery } from "$lib/server/surreal"
import { valid } from "$lib/server/id"
import { error } from "@sveltejs/kit"

type Replies = {
	author: {
		number: number
		username: string
	}
	content: {
		id: string
		text: string
		updated: string
	}[]
	dislikeCount: number
	dislikes: boolean
	id: string
	likeCount: number
	likes: boolean
	parentPost: {
		id: string
		title: string
	}
	parentPostId: string
	parentReplyId: null
	posted: string
	replies: Replies
	visibility: string
}[]

const SELECTFROM = () =>
	surql`
		SELECT
			*,
			(SELECT text, updated FROM $parent.content
			ORDER BY updated DESC) AS content,
			string::split(type::string(id), ":")[1] AS id,
			$forumPost as parentPost,
			string::split(type::string($forumPost.id), ":")[1] AS parentPostId,
			NONE as parentReplyId,
			(SELECT number, username FROM <-posted<-user)[0] as author,
			
			count(<-likes) as likeCount,
			count(<-dislikes) as dislikeCount,
			($user ∈ <-likes<-user.id) as likes,
			($user ∈ <-dislikes<-user.id) as dislikes,

			# again #
		FROM`

function SELECTREPLIES() {
	let rep = surql`
		(${SELECTFROM()} <-replyToReply<-forumReply) as replies`

	for (let i = 0; i < 9; i++)
		rep = rep.replace(
			/# again #/g,
			surql`(${SELECTFROM()} <-replyToReply<-forumReply) AS replies`,
		)

	return rep.replace(/# again #/g, "[] AS replies")
}

export async function load({ locals, params }) {
	if (!valid(params.post)) throw error(400, "Invalid post id")
	const post = (
		(await squery(surql`
			SELECT
				(SELECT username
				FROM <-posted<-user)[0] AS author
			FROM $forumPost`, {
			forumPost: `forumPost:${params.post}`,
			})) as {
			author: {
				username: string
			}
		}[]
	)[0]

	console.log(post)

	if (!post) throw error(404, "Post not found")

	const { user } = await authorise(locals)

	const forumReplies = (await squery(
		surql`
			SELECT
				*,
				(SELECT text, updated FROM $parent.content
				ORDER BY updated DESC) AS content,
				string::split(type::string(id), ":")[1] AS id,
				$forumPost as parentPost,
				string::split(type::string($forumPost.id), ":")[1] AS parentPostId,
				(IF ->replyToReply->forumReply.id THEN 
					string::split(type::string(
					->replyToReply[0]->forumReply[0].id), ":")[1]
				END) AS parentReplyId,
				(SELECT number, username FROM <-posted<-user)[0] as author,
				
				count(<-likes) as likeCount,
				count(<-dislikes) as dislikeCount,
				($user ∈ <-likes<-user.id) as likes,
				($user ∈ <-dislikes<-user.id) as dislikes,

				(SELECT
					title,
					string::split(type::string(id), ":")[1] AS id,
					->in[0]->forumCategory[0].name as forumCategoryName
				FROM $forumPost)[0] AS parentPost,

				${SELECTREPLIES()}
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
