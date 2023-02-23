import type { PageServerLoad } from "./$types"
import { authoriseUser } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { redirect } from "@sveltejs/kit"

export const load: PageServerLoad = async ({ locals }) => {
	const session = await authoriseUser(locals.validateUser())

	return {
		transactions: prisma.transaction.findMany({
			where: {
				OR: [{ receiverName: session.user.username }, { senderName: session.user.username }],
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
			},
			orderBy: {
				time: "desc",
			},
		}),
	}
}
