import surql from "$lib/surrealtag"
import { actions } from "../+page.server"
import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { squery } from "$lib/server/surreal"
import addLikes from "$lib/server/addLikes"
import { error } from "@sveltejs/kit"
import { Prisma } from "@prisma/client"
import { recurse, type Replies } from "../select"

const SELECTREPLIES = recurse(
	from => surql`(${from} <-replyToReply<-forumReply) AS replies`,
)

export async function load({ locals, params }) {
	if (!/^\d+$/.test(params.id))
		throw error(400, `Invalid asset id: ${params.id}`)

	const asset = (
		(await squery(
			surql`
				SELECT
					(SELECT username
					FROM <-created<-user)[0] AS creator
				FROM $asset`,
			{ asset: `asset:${params.id}` },
		)) as {
			creator: {
				username: string
			}
		}[]
	)[0]

	if (!asset) throw error(404, "Asset not found")

	const { user } = await authorise(locals)

	// Since prisma does not yet support recursive copying, we have to do it manually
	// const selectComments = {
	// 	// where: {
	// 	// 	OR: [{ visibility: Visibility.Visible }, { authorId: user.id }],
	// 	// },
	// 	select: {
	// 		id: true,
	// 		posted: true,
	// 		parentReplyId: true,
	// 		visibility: true,
	// 		author: {
	// 			select: {
	// 				username: true,
	// 				number: true,
	// 			},
	// 		},
	// 		content: {
	// 			orderBy: {
	// 				updated: Prisma.SortOrder.desc,
	// 			},
	// 			select: {
	// 				text: true,
	// 			},
	// 			take: 1,
	// 		},
	// 		replies: {},
	// 	},
	// }
	// for (let i = 0; i < 9; i++)
	// 	selectComments.select.replies = structuredClone(selectComments)

	// const assetComments = await prisma.assetComment.findUnique({
	// 	where: {
	// 		id: params.comment,
	// 	},
	// 	...selectComments,
	// })

	const assetComments = (await squery(
		surql`
			SELECT
				*,
				(SELECT text, updated FROM $parent.content
				ORDER BY updated DESC) AS content,
				string::split(type::string(id), ":")[1] AS id,
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
			FROM $assetComment`,
		{
			assetComment: `assetComment:${params.comment}`,
			forumPost: `forumPost:${params.id}`,
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

	if (!assetComments) throw error(404, "Comment not found")

	return {
		replies: assetComments,
		assetId: params.id,
		assetName: params.name,
		creator: asset.creator.username,
	}
}

export { actions }
