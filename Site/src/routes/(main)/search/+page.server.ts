import { error } from "@sveltejs/kit"
import { packageItems } from "economy/api"
import { UnlimitedAsset } from "economy/types"
import {
	searchAssets,
	searchGroups,
	searchPlaces,
	searchUsers,
} from "#lib/server/db/search.ts"
import { economyConnFailed } from "#lib/server/economy.ts"
import type { PageServerLoadEvent } from "./$types"

// bundle contents are owned in the Economy service, so the ids to hide come from there
async function packageItemIds(f: typeof globalThis.fetch): Promise<number[]> {
	const items = await packageItems(f)
	if (!items.ok) error(500, economyConnFailed)

	return [...items.value.set]
		.filter(i => i instanceof UnlimitedAsset)
		.map(i => i.ID)
}

export async function load({ fetch: f, url }: PageServerLoadEvent) {
	const query = url.searchParams.get("q") || ""
	const category = url.searchParams.get("c")?.toLowerCase() || ""
	if (!query) error(400, "Missing search query")

	// TODO: make this full-text search because that would be much nicer
	switch (category) {
		case "users": {
			// convenient, but easy to abuse
			// const foundUser = await findWhere(
			// 	"user",
			// 	"username = $query",
			// 	param
			// )
			// if (foundUser) redirect(302, `/user/${query}`)

			const users = await searchUsers(query)
			return { category, query, users }
		}
		case "places": {
			const places = await searchPlaces(query)
			return { category, places, query }
		}
		case "assets": {
			const assets = await searchAssets(query, await packageItemIds(f))
			return { assets, category, query }
		}
		case "groups": {
			const groups = await searchGroups(query)
			return { category, groups, query }
		}
	}
	error(400, "Invalid category")
}
