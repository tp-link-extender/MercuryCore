import { actions as postActions } from "../+page.server"
import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { roQuery } from "$lib/server/redis"
import { error } from "@sveltejs/kit"

export async function load({ locals, params }) {
	const asset = await prisma.asset.findUnique({
		where: {
			id: parseInt(params.id),
		},
		select: {
			creatorUser: true,
		},
	})

	if (!asset) throw error(404, "Asset not found")

	// Since prisma does not yet support recursive copying, we have to do it manually
	const selectComments: any = {
		// odd type errors in "replies: selectComments" if not any
		select: {
			id: true,
			posted: true,
			parentReplyId: true,
			author: {
				select: {
					username: true,
					number: true,
				},
			},
			content: {
				orderBy: {
					updated: "desc",
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

	const { user } = await authorise(locals)

	async function addLikes(asset: any) {
		const query = {
			user: user.username,
			id: asset.id,
		}
		asset["likeCount"] = await roQuery(
			"asset",
			"RETURN SIZE((:User) -[:likes]-> (:Comment { name: $id }))",
			query,
			true
		)
		asset["dislikeCount"] = await roQuery(
			"asset",
			"RETURN SIZE((:User) -[:dislikes]-> (:Comment { name: $id }))",
			query,
			true
		)
		asset["likes"] = !!(await roQuery(
			"asset",
			"MATCH (:User { name: $user }) -[r:likes]-> (:Comment { name: $id }) RETURN r",
			query
		))
		asset["dislikes"] = !!(await roQuery(
			"asset",
			"MATCH (:User { name: $user }) -[r:dislikes]-> (:Comment { name: $id }) RETURN r",
			query
		))

		if (asset.replies)
			asset.replies = await Promise.all(asset.replies.map(addLikes))

		return asset
	}

	return {
		replies: await Promise.all([assetComments].map(addLikes)),
		assetId: params.id,
		assetName: params.name,
		creator: asset?.creatorUser?.username,
	}
}

export const actions = postActions
