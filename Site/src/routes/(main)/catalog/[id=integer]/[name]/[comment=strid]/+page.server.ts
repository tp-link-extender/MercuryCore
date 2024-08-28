import { authorise } from "$lib/server/lucia"
import { type Replies, recurse } from "$lib/server/nestedReplies"
import { Record, equery, surql } from "$lib/server/surreal"
import { couldMatch, encode } from "$lib/urlName"
import { error, redirect } from "@sveltejs/kit"
import assetCommentsQuery from "./comments.surql"

const SELECTCOMMENTS = recurse("<-replyToComment<-assetComment")
const commentsQuery = assetCommentsQuery.replace(
	"_SELECTCOMMENTS",
	SELECTCOMMENTS
)

type Asset = {
	name: string
	creator: { username: string }
}

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
	const [[asset]] = await equery<Asset[][]>(
		surql`
			SELECT
				name,
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

	const slug = encode(asset.name)
	if (!couldMatch(asset.name, params.name))
		redirect(302, `/avatarshop/${id}/${slug}/${params.comment}`)

	return {
		replies: assetComments,
		assetId: params.id,
		assetName: params.name,
		creator: asset.creator.username,
		slug,
	}
}

export { actions } from "../+page.server"
