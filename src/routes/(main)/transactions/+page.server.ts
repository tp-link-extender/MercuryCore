import { authorise } from "$lib/server/lucia"
import { Record, equery } from "$lib/server/surreal"
import transactionsQuery from "./transactions.surql"

type Transaction = {
	amountSent: number
	link: string
	note: string
	receiver: BasicUser
	sender: BasicUser
	taxRate: number
	time: string
}

export async function load({ locals }) {
	const [transactions] = await equery<Transaction[][]>(transactionsQuery, {
		user: Record("user", (await authorise(locals)).user.id),
	})
	return { transactions }
}
