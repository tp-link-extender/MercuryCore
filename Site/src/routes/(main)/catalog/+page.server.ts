import { packageItems as ledgerPackageItems } from "economy/api"
import * as Econ from "economy/types"
import { error } from "@sveltejs/kit"
import { economyConnFailed } from "$lib/server/economy"
import pageQuery from "$lib/server/pageQuery"
import { db } from "$lib/server/surreal"
import catalogQuery from "./catalog.surql"

export type Asset = {
	name: string
	price: number
	id: number
}

// bundle contents are owned in the Economy service, so the ids to hide come from there
async function packageItemIds(f: typeof globalThis.fetch): Promise<number[]> {
	const items = await ledgerPackageItems(f)
	if (!items.ok) error(500, economyConnFailed)

	return [...items.value.set]
		.filter(i => i instanceof Econ.UnlimitedAsset)
		.map(i => i.ID)
}

export async function load({ fetch: f, url }) {
	const { page, checkPages } = pageQuery(url)
	// const type = url.searchParams.get("type") || ""
	// if (!intRegex.test(type)) error(400, "Invalid type parameter")

	const [, pages] = await db.query<[Asset[], number]>(catalogQuery, {
		page,
		packageItems: await packageItemIds(f),
		// type: +type,
	})
	checkPages(pages)
}
