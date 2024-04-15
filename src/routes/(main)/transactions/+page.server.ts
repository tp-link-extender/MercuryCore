import { authorise } from "$lib/server/lucia"
import { query, surql } from "$lib/server/surreal"

type Transaction = {
	amountSent: number
	id: string
	in: string
	link: string
	note: string
	out: string
	receiver: BasicUser
	sender: BasicUser
	taxRate: number
	time: string
}

export const load = async ({ locals }) => ({
	transactions: await query<Transaction>(import("./transactions.surql"), {
		user: `user:${(await authorise(locals)).user.id}`,
	}),
})
