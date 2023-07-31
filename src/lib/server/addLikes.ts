// This function requires juggling complex types between several files!
// You'll probably receieve type errors when using it.

import cql from "$lib/cyphertag"
import { roQuery } from "$lib/server/redis"

/**
 * Adds likes and dislikes properties to an object.
 * @param graphName The name of the graph to load likes from.
 * @param item The object to add likes and dislikes to.
 * @param type The type of item as defined in the graph database.
 * @param username The user's username.
 * @param id The id of the item in the graph database.
 * @param nextType The type of children of the item, eg. "Reply" if type is "Post".
 * @returns The item with likes and dislikes properties added.
 */
async function addLikes<
	ItemType extends {
		id: string | number
		replies: NextType
		[k: string]: any
	},
	NextType extends {
		id: string | number
		replies: NextType
		[k: string]: any
	}[] = ItemType["replies"],
>(
	graphName: string,
	type: string,
	item: ItemType,
	username: string,
	nextType: string = type,
) {
	const item2 = item as ItemType & {
		likeCount: number
		dislikeCount: number
		likes: boolean
		dislikes: boolean
		replies: {
			likeCount: number
			dislikeCount: number
			likes: boolean
			dislikes: boolean
		}[]
	}

	const query = { user: username, id: item2.id }

	const t = []
	if (item2.replies)
		for (const i of item2.replies)
			t.push(addLikes<NextType[number]>(graphName, nextType, i, username))

	if (!item2.id) {
		// Used for asset comments, as assets themselves can't be voted on
		await Promise.all(t)
		return item2
	}

	;[item2.likeCount, item2.dislikeCount, item2.likes, item2.dislikes] =
		await Promise.all([
			roQuery(
				graphName,
				cql`RETURN SIZE((:User) -[:likes]-> (:${type} { name: $id }))`,
				query,
				true,
			),
			roQuery(
				graphName,
				cql`RETURN SIZE((:User) -[:dislikes]-> (:${type} { name: $id }))`,
				query,
				true,
			),
			roQuery(
				graphName,
				cql`MATCH (:User { name: $user }) -[r:likes]-> (:${type} { name: $id }) RETURN r`,
				query,
			),
			roQuery(
				graphName,
				cql`MATCH (:User { name: $user }) -[r:dislikes]-> (:${type} { name: $id }) RETURN r`,
				query,
			),
			t,
		])

	item2.likes = !!item2.likes
	item2.dislikes = !!item2.dislikes

	return item2
}

export default addLikes
