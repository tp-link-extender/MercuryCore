import { error } from "@sveltejs/kit"
import { authorise } from "#lib/server/auth.ts"
import { assetCheckOf, assetSettingsOf } from "#lib/server/db/catalog.ts"
import { assetOwner, economyConnFailed } from "#lib/server/economy.ts"
import { encode } from "#lib/urlName.ts"
import type { PageServerLoadEvent } from "./$types"

export async function load({ fetch: f, locals, params }: PageServerLoadEvent) {
	const { user } = await authorise(locals)
	const id = Number(params.id)
	const check = await assetCheckOf(id)
	if (!check) error(404, "Not Found")

	const owner = await assetOwner(f, id, check.type)
	if (!owner.ok) error(500, economyConnFailed)
	const isOwner = owner.value?.id === user.id
	if (!isOwner && user.permissionLevel < 3)
		error(403, "You do not have permission to view this page")

	const asset = await assetSettingsOf(id)
	if (!asset) error(404, "Not Found")

	return {
		...asset,
		slug: encode(asset.name),
	}
}
