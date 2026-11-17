import { error } from "@sveltejs/kit"
import { packageItems as ledgerPackageItems } from "economy/api"
import { UnlimitedAsset } from "economy/types"
import { economyConnFailed } from "#lib/server/economy.ts"
import pageQuery from "#lib/server/pageQuery.ts"
import { db } from "#lib/server/surreal.ts"
import type { PageServerLoadEvent } from "./$types"
import catalogQuery from "./catalog.surql"

export interface Asset {
	id: number
	name: string
	price: number
}

// bundle contents are owned in the Economy service, so the ids to hide come from there
async function packageItemIds(f: typeof globalThis.fetch): Promise<number[]> {
	const items = await ledgerPackageItems(f)
	if (!items.ok) error(500, economyConnFailed)

	return [...items.value.set]
		.filter(i => i instanceof UnlimitedAsset)
		.map(i => i.ID)
}

export async function load({ fetch: f, url }: PageServerLoadEvent) {
	const { page, checkPages } = pageQuery(url)
	// const type = url.searchParams.get("type") || ""
	// if (!intRegex.test(type)) error(400, "Invalid type parameter")

	const [, pages] = await db.query<[Asset[], number]>(catalogQuery, {
		packageItems: await packageItemIds(f),
		page,
		// type: +type,
	})
	checkPages(pages)
}
