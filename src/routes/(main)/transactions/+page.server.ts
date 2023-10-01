import surql from "$lib/surrealtag"
import { authorise } from "$lib/server/lucia"
import { squery } from "$lib/server/surreal"

export async function load({ locals }) {
	const { user } = await authorise(locals)

	return {
		transactions: squery(surql`
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
			FROM $user<->transaction`, {
			user: `user:${user.id}`,
			}) as Promise<
			Array<{
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
			}>
		>,
	}
}
