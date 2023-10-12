import surql from "$lib/surrealtag"
import { squery } from "$lib/server/surreal"
import { authorise } from "$lib/server/lucia"
import { error } from "@sveltejs/kit"

export const load = async ({ locals }) => {
	const { user } = await authorise(locals)

	await squery(
		surql`
			UPDATE notification
			SET read = true
			WHERE out = $user`,
		{
			user: `user:${user.id}`,
		},
	)
}

export const actions = {
	default: async ({ locals, url }) => {
		const { user } = await authorise(locals),
			id = url.searchParams.get("s")
		if (!id) throw error(400)

		try {
			await squery(
				surql`
					IF $notification.* {
						UPDATE $notification
						SET read = true
					}`,
				{
					notification: `notification:${id}`,
				},
			)
		} catch (e: any) {
			throw error(400)
		}
	},
}
