import { authorise } from "$lib/server/lucia"
import { query, surql } from "$lib/server/surreal"

export async function load({ locals }) {
	const { user } = await authorise(locals)

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
			FROM $user<->transaction`,
			{ user: `user:${user.id}` },
		),
	}
}
