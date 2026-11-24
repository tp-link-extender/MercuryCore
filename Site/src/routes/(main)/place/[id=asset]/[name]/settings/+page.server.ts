import { error } from "@sveltejs/kit"
import { Place as EconPlace } from "economy/types"
import { authorise } from "#lib/server/auth.ts"
import { placeSettingsOf } from "#lib/server/db/places.ts"
import { economyConnFailed, ownsItem } from "#lib/server/economy.ts"
import { encode } from "#lib/urlName.ts"
import clientVersions from "../../../../games/create/clientVersions"
import type { PageServerLoadEvent } from "./$types"

export async function load({ fetch: f, locals, params }: PageServerLoadEvent) {
	const getPlace = await placeSettingsOf(Number(params.id))
	if (!getPlace) error(404, "Place not found")

	const { user } = await authorise(locals)
	const owns = await ownsItem(f, user.id, new EconPlace(Number(params.id)))
	if (!owns.ok) error(500, economyConnFailed)
	if (!owns.value && user.permissionLevel < 4)
		error(403, "You do not have permission to view this page.")

	return {
		...getPlace,
		clientVersions,
		slug: encode(getPlace.name),
	}
}
