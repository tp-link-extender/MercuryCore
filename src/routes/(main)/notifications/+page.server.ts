import { query, surql } from "$lib/server/surreal"
import { authorise } from "$lib/server/lucia"
import { error } from "@sveltejs/kit"

export const load = async ({ locals }) => {
	const { user } = await authorise(locals)

	await query(
		surql`
			UPDATE notification
			SET read = true
			WHERE out = $user`,
		{ user: `user:${user.id}` }
	)
}

export const actions = {
	default: async ({ locals, url }) => {
		const { user } = await authorise(locals)
		const id = url.searchParams.get("s")
		if (!id) error(400)

		try {
			await query(
				surql`
					IF $notification.* {
						UPDATE $notification
						SET read = true
					}`,
				{ notification: `notification:${id}` }
			)
		} catch (e) {
			error(400)
		}
	},
}
