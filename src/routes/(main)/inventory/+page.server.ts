import type { PageServerLoad } from "./$types"
import { authoriseUser } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"

export const load: PageServerLoad = async ({ locals }) => {
	console.time("inventory")
	const user = (await authoriseUser(locals.validateUser)).user

	const userExists = await prisma.user.findUnique({
		where: {
			number: user?.number,
		},
		select: {
			itemsOwned: true,
		},
	})

	console.timeEnd("inventory")

	return {
		items: userExists?.itemsOwned,
	}
}
