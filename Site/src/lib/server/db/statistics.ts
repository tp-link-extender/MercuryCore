import { dbQuery } from "#lib/server/db/query.ts"
import countsQuery from "./statistics/counts.surql"

/** Counts the users, places, groups, assets, friendships, follows and comments, in that order. */
export const siteStatistics = (): Promise<number[]> =>
	dbQuery<number[]>(countsQuery)
