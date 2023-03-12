import { auth, authoriseAdmin } from "$lib/server/lucia"
import { client } from "$lib/server/redis"
import { fail } from "@sveltejs/kit"
import ratelimit from "$lib/server/ratelimit"
import { prisma } from "$lib/server/prisma"

// Make sure a user is an administrator before loading the page.
export async function load ({ locals }) {
	await authoriseAdmin(locals)

    return {
        transactions: prisma.transaction.findMany({
            select: {
                id: true,
                time: true,
                amountSent: true,
                taxRate: true,
                note: true,
                link: true,
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
            },
            orderBy: {
                time: "desc",
            },
        }),
	}
}
