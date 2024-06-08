import { authorise } from "$lib/server/lucia"
import { equery } from "$lib/server/surreal"
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
	await authorise(locals, 5)

	const [transactions] = await equery<Transaction[][]>(transactionsQuery)
	return { transactions }
}
