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

export async function load({ locals }) {
	await authorise(locals, 5)

	return {
		transactions: await query<Transaction>(
			surql`
				SELECT
					*,
					(SELECT number, status, username
					FROM in.*)[0] AS sender,
					(SELECT number, status, username
					FROM out.*)[0] AS receiver
				FROM transaction`
		),
	}
}
