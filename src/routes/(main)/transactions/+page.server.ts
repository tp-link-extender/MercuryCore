import { authorise } from "$lib/server/lucia"
import { query, surql } from "$lib/server/surreal"

type Transaction = {
	amountSent: number
	id: string
	in: string
	link: string
	note: string
	out: string
	receiver: {
		number: number
		status: "Playing" | "Online" | "Offline"
		username: string
	}
	sender: {
		number: number
		status: "Playing" | "Online" | "Offline"
		username: string
	}
	taxRate: number
	time: string
}

export const load = async ({ locals }) => ({
	transactions: await query<Transaction>(
		surql`
			SELECT
				*,
				(SELECT number, status, username
				FROM in.*)[0] AS sender,
				(SELECT number, status, username
				FROM out.*)[0] AS receiver
			FROM $user<->transaction`,
		{ user: `user:${(await authorise(locals)).user.id}` }
	),
})
