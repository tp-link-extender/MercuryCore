import { authorise } from "$lib/server/lucia"
import { query } from "$lib/server/surreal"
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

export async function load({ locals }) {
	await authorise(locals, 5)

	return {
		transactions: await query<Transaction>(import("./transactions.surql")),
	}
}
