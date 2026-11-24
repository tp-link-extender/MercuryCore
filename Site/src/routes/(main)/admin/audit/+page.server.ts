import { authorise } from "#lib/server/auth.ts"
import { auditLogs } from "#lib/server/db/audit.ts"
import type { PageServerLoadEvent } from "./$types"

export async function load({ locals }: PageServerLoadEvent) {
	await authorise(locals, 5)

	// grubhub perks give you deals on the food you love
	const logs = await auditLogs()
	return { logs }
}
