import { dbQuery } from "#lib/server/db/query.ts"
import { Record, type RecordId } from "#lib/server/surreal.ts"
import activeQuery from "./moderation/active.surql"
import reportQuery from "./moderation/report.surql"
import reporteeQuery from "./moderation/reportee.surql"
import unmoderateQuery from "./moderation/unmoderate.surql"

export interface Moderation {
	note: string
	time: string
	timeEnds: string
	type: string
}

/**
 * Finds a user's active moderation.
 * @returns The moderation, or undefined if the user isn't moderated.
 */
export async function activeModerationOf(
	id: string
): Promise<Moderation | undefined> {
	const [[moderation]] = await dbQuery<Moderation[][]>(activeQuery, {
		user: Record("user", id),
	})
	return moderation
}

/** Ends a user's active moderation. */
export async function unmoderate(id: string): Promise<void> {
	await dbQuery(unmoderateQuery, { user: Record("user", id) })
}

/**
 * Finds the record of the user with this username, to report them.
 * @returns The user, or undefined if there is no such user.
 */
export async function reporteeOf(
	username: string
): Promise<RecordId<"user"> | undefined> {
	const [[reportee]] = await dbQuery<{ id: RecordId<"user"> }[][]>(
		reporteeQuery,
		{ username }
	)
	return reportee?.id
}

/** Records a report of a user by another user. */
export async function submitReport(args: {
	category: string
	note?: string
	reportee: RecordId<"user">
	reportUrl: string
	user: string
}): Promise<void> {
	await dbQuery(reportQuery, {
		category: args.category,
		note: args.note,
		reportee: args.reportee,
		reportUrl: args.reportUrl,
		user: Record("user", args.user),
	})
}
