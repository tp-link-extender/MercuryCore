import type { PageServerLoad } from "./$types"
import { prisma } from "$lib/server/prisma"
import { error } from "@sveltejs/kit"

export const load: PageServerLoad = async ({ locals, params }) => {
	console.time("place")
	const getItem = await prisma.item.findUnique({
		where: {
			id: params.id,
		},
		select: {
			name: true,
			creator: {
				select: {
					number: true,
					displayname: true,
				}
			},
		},
	})
	console.timeEnd("place")
	if (getItem) {
		return {
			name: getItem.name,
			creator: getItem.creator,
			description: "item description",//getItem.description,
			likes: true,
			dislikes: false,
			likeCount: 1,
			dislikeCount: 1,
		}
	} else throw error(404, `Not found: /item/${params.id}`)
}
