import type { PageServerLoad } from "./$types"
import { prisma } from "$lib/server/prisma"
import { redirect } from "@sveltejs/kit"

export const load: PageServerLoad = async ({ locals }) => {
	const session = await locals.validateUser()
	if (!session.session) throw redirect(302, "/login")

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
