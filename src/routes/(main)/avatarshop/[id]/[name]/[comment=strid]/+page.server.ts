import { actions } from "../+page.server"
import { authorise } from "$lib/server/lucia"
import { query, squery, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import { recurse, type Replies } from "$lib/server/nestedReplies"

const SELECTREPLIES = recurse(
	from => surql`(${from} <-replyToComment<-assetComment) AS replies`,
	"replyToComment",
	"assetComment"
)

type AssetComment = Replies[number] & {
	parentPost: {
		title: string
		id: string
		forumCategoryName: string
	}
}

export async function load({ locals, params }) {
	if (!/^\d+$/.test(params.id)) error(400, `Invalid asset id: ${params.id}`)

	const asset = await squery<{
		creator: {
			username: string
		}
	}>(
		surql`
			SELECT
				(SELECT username
				FROM <-created<-user)[0] AS creator
			FROM $asset`,
		{ asset: `asset:${params.id}` }
	)

	if (!asset) error(404, "Asset not found")

	const { user } = await authorise(locals)

	const assetComments = await query<AssetComment>(
		surql`
			SELECT
				*,
				(SELECT text, updated FROM $parent.content
				ORDER BY updated DESC) AS content,
				meta::id(id) AS id,
				(IF ->replyToComment->assetComment.id THEN
					meta::id(->replyToComment[0]->assetComment[0].id)
				END) AS parentReplyId,
				(SELECT number, username FROM <-posted<-user)[0] AS author,

				count(<-likes) - count(<-dislikes) AS score,
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
		}
	)

	if (!assetComments) error(404, "Comment not found")

	return {
		replies: assetComments,
		assetId: params.id,
		assetName: params.name,
		creator: asset.creator.username,
	}
}

export { actions }
