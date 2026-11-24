import { dbQuery } from "#lib/server/db/query.ts"
import { Record, type RecordId } from "#lib/server/surreal.ts"
import activeQuery from "./moderation/active.surql"
import assocReportQuery from "./moderation/assocReport.surql"
import moderateQuery from "./moderation/moderate.surql"
import moderateeQuery from "./moderation/moderatee.surql"
import reportQuery from "./moderation/report.surql"
import reporteeQuery from "./moderation/reportee.surql"
import unbanQuery from "./moderation/unban.surql"
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

/**
 * Finds the note and reportee of a report, for showing it while moderating.
 * @returns The report, or undefined if there is no such report.
 */
export async function reportOf(
	id: string
): Promise<{ note: string; reportee: string } | undefined> {
	const [report] = await dbQuery<
		({ note: string; reportee: string } | undefined)[]
	>(assocReportQuery, { report: Record("report", id) })
	return report
}

/**
 * Finds a user by username, for moderating them.
 * @returns The user's id and permission level, or undefined if there is no such user.
 */
export async function moderateeOf(
	username: string
): Promise<{ id: string; permissionLevel: number } | undefined> {
	const [[moderatee]] = await dbQuery<
		{ id: string; permissionLevel: number }[][]
	>(moderateeQuery, { username })
	return moderatee
}

/** Starts a moderation of a user, which is logged by the moderator who made it. */
export async function moderate(args: {
	moderatee: RecordId<"user">
	moderationAction: string
	note: string
	reason: string
	timeEnds: Date
	user: RecordId<"user">
}): Promise<void> {
	await dbQuery(moderateQuery, args)
}

/** Ends a user's moderations, which is logged by the moderator who did it. */
export async function unban(args: {
	moderatee: RecordId<"user">
	note: string
	user: RecordId<"user">
}): Promise<void> {
	await dbQuery(unbanQuery, args)
}
