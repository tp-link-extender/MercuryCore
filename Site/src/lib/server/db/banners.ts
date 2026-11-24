import { dbQuery } from "#lib/server/db/query.ts"
import {
	Banner as BannerTable,
	db,
	Record,
	type RecordId,
} from "#lib/server/surreal.ts"
import activeQuery from "./banners/active.surql"
import activeCountQuery from "./banners/activeCount.surql"
import allQuery from "./banners/all.surql"
import updateQuery from "./banners/update.surql"

export interface Banner {
	bgColour: string
	body: string
	id: string
	textLight: boolean
}

/** Finds the banners shown on every page. */
export async function activeBanners(): Promise<Banner[]> {
	const [banners] = await dbQuery<Banner[][]>(activeQuery)
	return banners
}

export interface BannerRow {
	active: boolean
	bgColour: string
	body: string
	creator: BasicUser
	id: string
	textLight: boolean
}

/** Lists every banner that hasn't been deleted, for administrators. */
export async function allBanners(): Promise<BannerRow[]> {
	const [banners] = await dbQuery<BannerRow[][]>(allQuery)
	return banners
}

/** Counts the banners that are shown. There can be at most three. */
export async function activeBannerCount(): Promise<number> {
	const [count] = await dbQuery<number[]>(activeCountQuery)
	return count
}

export async function createBanner(args: {
	bgColour: string
	body: string
	creator: RecordId<"user">
	textLight: boolean
}): Promise<void> {
	await db.insert(BannerTable, { ...args, deleted: false })
}

/**
 * Changes a banner, and logs the change with the administrator who made it.
 * @returns Whether the banner was found.
 */
export async function updateBanner(args: {
	action: string
	banner: string
	changes: { [_: string]: unknown }
	detail: string
	user: RecordId<"user">
}): Promise<boolean> {
	const results = await dbQuery<[null, null, boolean]>(updateQuery, {
		action: args.action,
		banner: Record("banner", args.banner),
		changes: args.changes,
		detail: args.detail,
		user: args.user,
	})
	// The last statement returns whether the banner was found
	return results[2]
}
