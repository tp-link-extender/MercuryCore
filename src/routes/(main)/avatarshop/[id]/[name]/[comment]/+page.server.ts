import surql from "$lib/surrealtag"
import { actions } from "../+page.server"
import { authorise } from "$lib/server/lucia"
import { squery } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import { recurse, type Replies } from "../select"

const SELECTREPLIES = recurse(
	from => surql`(${from} <-replyToComment<-assetComment) AS replies`,
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

	const assetComments = (await squery(
		surql`
			SELECT
				*,
				(SELECT text, updated FROM $parent.content
				ORDER BY updated DESC) AS content,
				meta::id(id) AS id,
				(IF ->replyToComment->assetComment.id THEN 
					string::split(type::string(
						->replyToComment[0]->assetComment[0].id), ":")[1]
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
