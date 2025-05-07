import { authorise } from "$lib/server/auth"
import type { Reply } from "$lib/server/nestedReplies"
import { Record, db } from "$lib/server/surreal"
import { couldMatch, encode } from "$lib/urlName"
import { error, redirect } from "@sveltejs/kit"
import assetQuery from "./asset.surql"
import assetCommentsQuery from "./comments.surql"

type Asset = {
	name: string
	creator: { username: string }
}

interface AssetComment extends Reply {
	parentPost: {
		title: string
		id: string
		forumCategoryId: string
	}
}

export async function load({ locals, params }) {
	const { user } = await authorise(locals)
	const id = +params.id
	const [[asset]] = await db.query<Asset[][]>(assetQuery, {
		asset: Record("asset", id),
	})
	if (!asset) error(404, "Asset not found")

	const [assetComments] = await db.query<AssetComment[][]>(
		assetCommentsQuery,
		{
			assetComment: Record("assetComment", params.comment),
			asset: Record("asset", id),
			user: Record("user", user.id),
		}
	)
	if (!assetComments) error(404, "Comment not found")

	const slug = encode(asset.name)
	if (!couldMatch(asset.name, params.name))
		redirect(302, `/catalog/${id}/${slug}/${params.comment}`)

	return {
		replies: assetComments,
		assetId: params.id,
		assetName: params.name,
		creator: asset.creator.username,
		slug,
	}
}

export { actions } from "../+page.server"
