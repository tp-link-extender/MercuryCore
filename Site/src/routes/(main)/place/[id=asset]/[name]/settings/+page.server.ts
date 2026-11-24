import { error } from "@sveltejs/kit"
import { Place as EconPlace } from "economy/types"
import { authorise } from "#lib/server/auth.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import { economyConnFailed, ownsItem } from "#lib/server/economy.ts"
import { Record } from "#lib/server/surreal.ts"
import { encode } from "#lib/urlName.ts"
import clientVersions from "../../../../games/create/clientVersions"
import type { PageServerLoadEvent } from "./$types"
import settingsQuery from "./settings.surql"

interface Place {
	clientVersion: number
	created: string
	dedicated: boolean
	description: string
	id: string // graah
	maxPlayers: number
	name: string
	privateServer: boolean
	privateTicket: string
	serverAddress: string
	serverPing: number
	serverPort: number
	serverTicket: string
	updated: Date
}

async function placeQuery(id: number) {
	const [[place]] = await dbQuery<Place[][]>(settingsQuery, {
		place: Record("place", id),
	})
	return place
}

export async function load({ fetch: f, locals, params }: PageServerLoadEvent) {
	const getPlace = await placeQuery(Number(params.id))
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
