import { error } from "@sveltejs/kit"
import { inventory } from "economy/api"
import { Group as EconGroup, User as EconUser, Place } from "economy/types"
import { authorise } from "#lib/server/auth.ts"
import { ownedGroupsOf } from "#lib/server/db/groups.ts"
import { ownedPlacesOf } from "#lib/server/db/places.ts"
import { userPageOf } from "#lib/server/db/social.ts"
import { economyConnFailed } from "#lib/server/economy.ts"
import { Record } from "#lib/server/surreal.ts"
import type { PageServerLoadEvent } from "./$types"

export async function load({ fetch: f, locals, params }: PageServerLoadEvent) {
	const { user } = await authorise(locals)
	const userExists = await userPageOf(
		params.username,
		Record("user", user.id)
	)
	if (!userExists) error(404, "Not Found")

	const inv = await inventory(f, new EconUser(userExists.id))
	if (!inv.ok) error(500, economyConnFailed)

	const owned = [...inv.value.One]
	const placeIds = owned.filter(i => i instanceof Place).map(i => i.ID)
	const groupIds = owned.filter(i => i instanceof EconGroup).map(i => i.ID)

	const places = await ownedPlacesOf(placeIds)
	const groupsOwned = await ownedGroupsOf(groupIds)

	return { ...userExists, groupsOwned, places }
}
