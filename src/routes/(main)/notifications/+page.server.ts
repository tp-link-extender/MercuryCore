import surql from "$lib/surrealtag"
import { prisma } from "$lib/server/prisma"
import { squery } from "$lib/server/surreal"
import { authorise } from "$lib/server/lucia"
import { fail } from "@sveltejs/kit"

export const load = async ({ locals }) => {
	const { user } = await authorise(locals)

	console.log(await squery(
		surql`
			UPDATE notification
			SET read = true
			WHERE out = $user`,
		{
			user: `user:${user.id}`,
		},
	))
}

export const actions = {
	default: async ({ locals, url }) => {
		const { user } = await authorise(locals),
			id = url.searchParams.get("s")
		if (!id) return fail(400)

		try {
			await prisma.notification.updateMany({
				where: {
					id,
					receiverId: user.id,
				},
				data: {
					read: true,
				},
			})
		} catch (e: any) {
			return fail(400)
		}
	},
}
