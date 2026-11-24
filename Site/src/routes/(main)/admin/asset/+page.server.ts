import { error } from "@sveltejs/kit"
import { authorise } from "#lib/server/auth.ts"
import { pendingAssets } from "#lib/server/db/catalog.ts"
import { assetOwner, economyConnFailed } from "#lib/server/economy.ts"
import type { PageServerLoadEvent } from "./$types"

export async function load({ fetch: f, locals }: PageServerLoadEvent) {
	await authorise(locals, 3)

	const assets = await pendingAssets()

	const withOwners = await Promise.all(
		assets.map(async asset => {
			const owner = await assetOwner(f, asset.id, asset.type)
			if (!owner.ok) error(500, economyConnFailed)
			return Object.assign(asset, { owner: owner.value })
		})
	)

	return { assets: withOwners }
}
