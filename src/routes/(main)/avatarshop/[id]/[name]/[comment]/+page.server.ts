import { actions } from "../+page.server"
import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import addLikes from "$lib/server/addLikes"
import { error } from "@sveltejs/kit"
import { Prisma } from "@prisma/client"

export async function load({ locals, params }) {
	const getAsset = await prisma.asset.findUnique({
		where: {
			id: parseInt(params.id),
		},
		select: {
			creatorUser: true,
		},
	})

	if (!getAsset) throw error(404, "Asset not found")

	// Since prisma does not yet support recursive copying, we have to do it manually
	const selectComments = {
		// where: {
		// 	OR: [{ visibility: Visibility.Visible }, { authorId: user.id }],
		// },
		select: {
			id: true,
			posted: true,
			parentReplyId: true,
			visibility: true,
			author: {
				select: {
					username: true,
					number: true,
				},
			},
			content: {
				orderBy: {
					updated: Prisma.SortOrder.desc,
				},
				select: {
					text: true,
				},
				take: 1,
			},
			replies: {},
		},
	}
	for (let i = 0; i < 9; i++)
		selectComments.select.replies = structuredClone(selectComments)

	const assetComments = await prisma.assetComment.findUnique({
		where: {
			id: params.comment,
		},
		...selectComments,
	})

	if (!assetComments) throw error(404, "Comment not found")

	const { user } = await authorise(locals),
		commentsWithLikes = await addLikes<typeof assetComments>(
			"asset",
			"Comment",
			assetComments,
			user.username,
		)

	return {
		replies: [commentsWithLikes],
		assetId: params.id,
		assetName: params.name,
		creator: getAsset?.creatorUser?.username,
	}
}

export { actions }
