import surql from "$lib/surrealtag"
import { authorise } from "$lib/server/lucia"
import { query } from "$lib/server/surreal"

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
				username: string
			}
			sender: {
				number: number
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
					username
				FROM in.*)[0] AS sender,
				(SELECT
					number,
					username
				FROM out.*)[0] AS receiver
			FROM transaction`,
		),
	}
}
