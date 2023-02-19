import type { PageServerLoad, Actions } from "./$types"
import { prisma, transaction } from "$lib/server/prisma"
import { Query, roQuery } from "$lib/server/redis"
import { error, fail, redirect } from "@sveltejs/kit"

export const load: PageServerLoad = async ({ locals, params }) => {
	console.time("item")
	const session = await locals.validateUser()
	const item = await prisma.item.findUnique({
		where: {
			id: params.id,
		},
		select: {
			name: true,
			price: true,
			creator: {
				select: {
					number: true,
					displayname: true,
				},
			},
			owners: {
				where: {
					id: session?.user?.userId,
				},
			},
		},
	})
	console.timeEnd("item")

	if (item) {
		const query = {
			params: {
				user: session.user?.username || "",
				itemid: params.id,
			},
		}
		return {
			name: item.name,
			price: item.price,
			creator: item.creator,
			owned: item.owners.length > 0,
			description: "item description", //item.description,
			likeCount: roQuery("RETURN SIZE(() -[:likes]-> (:Item { name: $itemid }))", query, true),
			dislikeCount: roQuery("RETURN SIZE(() -[:dislikes]-> (:Item { name: $itemid }))", query, true),
			likes: session ? roQuery("MATCH (:User { name: $user }) -[r:likes]-> (:Item { name: $itemid }) RETURN r", query) : false,
			dislikes: session ? roQuery("MATCH (:User { name: $user }) -[r:dislikes]-> (:Item { name: $itemid }) RETURN r", query) : false,
		}
	} else throw error(404, "Not found")
}

export const actions: Actions = {
	default: async ({ request, locals, params }) => {
		const session = await locals.validateUser()
		if (!session.session) throw redirect(302, "/login")

		const data = await request.formData()
		const action = data.get("action")?.toString() || ""

		if (
			!(await prisma.item.findUnique({
				where: {
					id: params.id,
				},
			}))
		)
			return fail(404, { msg: "Not found" })

		const query = {
			params: {
				user: session.user.username,
				itemid: params.id, // item id (unique)
			},
		}

		console.log("Action:", action)

		try {
			switch (action) {
				case "buy":
					const item = await prisma.item.findUnique({
						where: {
							id: params.id,
						},
						select: {
							price: true,
							creator: true,
							owners: {
								where: {
									id: session?.user?.userId,
								},
							},
						},
					})
					if (!item) return fail(404, { msg: "Not found" })
					if ((item.owners || []).length > 0) return fail(400, { msg: "You already own this item" })

					if (item.price != 0)
						try {
							await transaction({ id: session.user.userId }, { id: item.creator.id }, item.price)
						} catch (e: any) {
							console.log(e.message)
							return fail(400, { msg: e.message })
						}

					await prisma.user.update({
						where: {
							id: session.user.userId,
						},
						data: {
							itemsOwned: {
								connect: {
									id: params.id,
								},
							},
						},
					})

					break
				case "delete":
					const item2 = await prisma.item.findUnique({
						// cAnnOt rEDeCLaRE bLoCK-SCOpeD varIabLE
						where: {
							id: params.id,
						},
						select: {
							price: true,
							creator: true,
							owners: {
								where: {
									id: session?.user?.userId,
								},
							},
						},
					})
					if (!item2) throw error(404, "Not found")
					if ((item2?.owners || []).length < 1) throw error(400, "You don't own this item")

					await prisma.user.update({
						where: {
							id: session.user.userId,
						},
						data: {
							itemsOwned: {
								disconnect: {
									id: params.id,
								},
							},
						},
					})

					break
				case "like":
					await Query(
						`
						MATCH (u:User { name: $user }) -[r:dislikes]-> (p:Item { name: $itemid })
						DELETE r
						`,
						query
					)
					await Query(
						`
						MERGE (u:User { name: $user })
						MERGE (p:Item { name: $itemid })
						MERGE (u) -[:likes]-> (p)
						`,
						query
					)
					break
				case "unlike":
					await Query(
						`
						MATCH (u:User { name: $user }) -[r:likes]-> (p:Item { name: $itemid })
						DELETE r
						`,
						query
					)
					break
				case "dislike":
					await Query(
						`
						MATCH (u:User { name: $user }) -[r:likes]-> (p:Item { name: $itemid })
						DELETE r
						`,
						query
					)
					await Query(
						`
						MERGE (u:User { name: $user })
						MERGE (p:Item { name: $itemid })
						MERGE (u) -[:dislikes]-> (p)
						`,
						query
					)
					break
				case "undislike":
					await Query(
						`
						MATCH (u:User { name: $user }) -[r:dislikes]-> (p:Item { name: $itemid })
						DELETE r
						`,
						query
					)
					break
			}
		} catch (e) {
			console.error(e)
			throw error(500)
		}
	},
}
