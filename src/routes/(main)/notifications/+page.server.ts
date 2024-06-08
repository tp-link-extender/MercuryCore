import { authorise } from "$lib/server/lucia"
import { RecordId, equery, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"

export const load = async ({ locals }) => {
	const { user } = await authorise(locals)
	await equery(surql`UPDATE notification SET read = true WHERE out = $user`, {
		user: new RecordId("user", user.id),
	})
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ locals, url }) => {
	const { user } = await authorise(locals)
	const id = url.searchParams.get("s")
	if (!id) error(400)

	try {
		await equery(
			surql`
				IF $notification.* {
					UPDATE $notification SET read = true WHERE out = $user
				}`,
			{
				notification: new RecordId("notification", id),
				user: new RecordId("user", user.id),
			}
		)
	} catch (e) {
		error(400)
	}
}
