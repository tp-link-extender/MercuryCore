import { authorise } from "$lib/server/lucia"
import { type Replies, recurse } from "$lib/server/nestedReplies"
import { Record, equery, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import { actions } from "../+page.server"
import assetCommentsQuery from "./comments.surql"

const SELECTCOMMENTS = recurse("<-replyToComment<-assetComment")
const commentsQuery = assetCommentsQuery.replace("_SELECTCOMMENTS", SELECTCOMMENTS)

type AssetComment = Replies[number] & {
	parentPost: {
		title: string
		id: string
		forumCategoryName: string
	}
}

export async function load({ locals, params }) {
	const { user } = await authorise(locals)
	const id = +params.id
	const [[asset]] = await equery<{ creator: { username: string } }[][]>(
		surql`
			SELECT
				(SELECT username FROM <-created<-user)[0] AS creator
			FROM ${Record("asset", id)}`
	)
	if (!asset) error(404, "Asset not found")

	
	const [assetComments] = await equery<AssetComment[][]>(commentsQuery, {
		assetComment: Record("assetComment", params.comment),
		asset: Record("asset", id),
		user: Record("user", user.id),
	})
	if (!assetComments) error(404, "Comment not found")

	return {
		replies: assetComments,
		assetId: params.id,
		assetName: params.name,
		creator: asset.creator.username,
	}
}

export { actions }
