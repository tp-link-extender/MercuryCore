import type { PageServerLoad } from "./$types"
import { authoriseUser } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"

export const load: PageServerLoad = async ({ locals }) => {
	const user = (await authoriseUser(locals.validateUser())).user

	return {
		transactions: prisma.transaction.findMany({
			where: {
				OR: [{ receiverName: user.username }, { senderName: user.username }],
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
						displayname: true,
					},
				},
				receiver: {
					select: {
						image: true,
						number: true,
						displayname: true,
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
