import { error } from "@sveltejs/kit"
import { inventory } from "economy/api"
import { Group as EconGroup, User as EconUser, Place } from "economy/types"
import { authorise } from "#lib/server/auth.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import { economyConnFailed } from "#lib/server/economy.ts"
import { Record } from "#lib/server/surreal.ts"
import type { Group } from "../../groups/+page.server"
import type { PageServerLoadEvent } from "./$types"
import ownedGroupsQuery from "./ownedGroups.surql"
import ownedPlacesQuery from "./ownedPlaces.surql"
import userQuery from "./user.surql"

interface OwnedPlace {
	dislikeCount: number
	id: number
	likeCount: number
	name: string
	playerCount: number
}

interface User extends BasicUser {
	comments: {
		id: string
		created: Date
		content: string
		visibility: string
	}[]
	description: string
	follower: boolean
	followerCount: number
	following: boolean
	followingCount: number
	friendCount: number
	friends: boolean
	groups: Group[]
	groupsOwned: Group[]
	id: string
	incomingRequest: boolean
	outgoingRequest: boolean
	permissionLevel: number
	places: OwnedPlace[]
}

export async function load({ fetch: f, locals, params }: PageServerLoadEvent) {
	const { user } = await authorise(locals)
	const [[userExists]] = await dbQuery<User[][]>(userQuery, {
		...params,
		user: Record("user", user.id),
	})
	if (!userExists) error(404, "Not Found")

	const inv = await inventory(f, new EconUser(userExists.id))
	if (!inv.ok) error(500, economyConnFailed)

	const owned = [...inv.value.One]
	const placeIds = owned.filter(i => i instanceof Place).map(i => i.ID)
	const groupIds = owned.filter(i => i instanceof EconGroup).map(i => i.ID)

	const [places] = await dbQuery<OwnedPlace[][]>(ownedPlacesQuery, {
		ids: placeIds.map(id => Record("place", id)),
	})
	const [groupsOwned] = await dbQuery<Group[][]>(ownedGroupsQuery, {
		ids: groupIds.map(id => Record("group", id)),
	})

	return { ...userExists, groupsOwned, places }
}
