import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"

export async function load({ locals }) {
	console.time("inventory")
	const { user } = await authorise(locals.validateUser)

	const userExists = await prisma.user.findUnique({
		where: {
			number: user.number,
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
