import { authorise } from "$lib/server/lucia"
import { Record, equery, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"

export const load = async ({ locals }) => {
	const { user } = await authorise(locals)
	await equery(surql`UPDATE notification SET read = true WHERE out = $user`, {
		user: Record("user", user.id),
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
				notification: Record("notification", id),
				user: Record("user", user.id),
			}
		)
	} catch (e) {
		error(400)
	}
}
