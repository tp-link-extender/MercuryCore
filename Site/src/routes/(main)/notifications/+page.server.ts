import { authorise } from "#lib/server/auth.ts"
import { markAllNotificationsRead } from "#lib/server/db/notifications.ts"
import { Record } from "#lib/server/surreal.ts"
import type { PageServerLoadEvent } from "./$types"

export async function load({ locals }: PageServerLoadEvent) {
	const { user } = await authorise(locals)

	await markAllNotificationsRead(Record("user", user.id))
}
