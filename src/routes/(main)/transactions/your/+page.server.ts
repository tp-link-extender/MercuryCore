import { authoriseUser } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"

export async function load({ locals }) {
	const user = (await authoriseUser(locals.validateUser)).user

	return {
		transactions: prisma.transaction.findMany({
			where: {
				OR: [
					{ receiverName: user.username },
					{ senderName: user.username },
				],
			},
			select: {
				id: true,
				time: true,
				amountSent: true,
				taxRate: true,
				sender: {
					select: {
						image: true,
						number: true,
						username: true,
					},
				},
				receiver: {
					select: {
						image: true,
						number: true,
						username: true,
					},
				},
				note: true,
				link: true,
			},
			orderBy: {
				time: "desc",
			},
		}),
	}
}
