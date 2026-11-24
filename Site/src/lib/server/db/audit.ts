import { dbQuery } from "#lib/server/db/query.ts"
import type { RecordId } from "#lib/server/surreal.ts"
import logsQuery from "./audit/logs.surql"
import writeQuery from "./audit/write.surql"

export interface AuditLog {
	action: "Account" | "Administration" | "Economy" | "Moderation"
	created: Date
	note: string
	user: BasicUser
}

/** Lists the audit log, newest first. */
export async function auditLogs(): Promise<AuditLog[]> {
	const [logs] = await dbQuery<AuditLog[][]>(logsQuery)
	return logs
}

/** Records an action in the audit log, naming the user who did it. */
export async function writeAuditLog(
	action: AuditLog["action"],
	note: string,
	user: RecordId<"user">
): Promise<void> {
	await dbQuery(writeQuery, { action, note, user })
}
