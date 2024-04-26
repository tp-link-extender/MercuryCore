import { actions } from "../+page.server"
import { authorise } from "$lib/server/lucia"
import { RecordId, equery, surql, surrealql, unpack } from "$lib/server/surreal"
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

const assetCommentsQuery = await unpack(import("./comments.surql"))

export async function load({ locals, params }) {
	const { user } = await authorise(locals)

	const [[asset]] = await equery<{ creator: { username: string } }[][]>(
		surrealql`
			SELECT
				(SELECT username
				FROM <-created<-user)[0] AS creator
			FROM ${new RecordId("asset", params.id)}`
	)
	if (!asset) error(404, "Asset not found")

	const [assetComments] = await equery<AssetComment[][]>(
		assetCommentsQuery.replace("_SELECTREPLIES", SELECTREPLIES),
		{
			assetComment: new RecordId("assetComment", params.comment),
			forumPost: new RecordId("forumPost", params.id),
			user: new RecordId("user", user.id),
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
