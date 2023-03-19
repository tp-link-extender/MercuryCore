import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"

export async function load({ locals }) {
	const { user } = await authorise(locals.validateUser)

	return {
		transactions: prisma.transaction.findMany({
			where: {
				OR: [
					{ receiverName: user.username },
					{ senderName: user.username },
				],
			},
			include: {
				sender: true,
				receiver: true,
			},
			orderBy: {
				time: "desc",
			},
		}),
	}
}
