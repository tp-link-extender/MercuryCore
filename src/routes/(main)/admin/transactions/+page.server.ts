import { authorise } from "$lib/server/lucia"
import { query, surql } from "$lib/server/surreal"

// Make sure a user is an administrator before loading the page.
export async function load({ locals }) {
	await authorise(locals, 5)

	return {
		transactions: query<{
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
		}>(
			surql`
			SELECT
				*,
				(SELECT
					number,
					status,
					username
				FROM in.*)[0] AS sender,
				(SELECT
					number,
					status,
					username
				FROM out.*)[0] AS receiver
			FROM transaction`,
		),
	}
}
