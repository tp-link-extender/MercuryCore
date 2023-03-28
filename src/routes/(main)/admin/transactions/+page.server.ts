import { auth, authorise } from "$lib/server/lucia"
import { client } from "$lib/server/redis"
import { fail } from "@sveltejs/kit"
import ratelimit from "$lib/server/ratelimit"
import { prisma } from "$lib/server/prisma"

// Make sure a user is an administrator before loading the page.
export async function load({ locals }) {
	await authorise(locals, 5)

	return {
		transactions: prisma.transaction.findMany({
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
