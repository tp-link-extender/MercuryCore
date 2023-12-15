import { authorise } from "$lib/server/lucia"
import { query, surql } from "$lib/server/surreal"

export async function load({ locals }) {
	const { user } = await authorise(locals)

	return {
		users: await query<{
			number: number
			status: "Playing" | "Online" | "Offline"
			username: string
		}>(
			surql`
				SELECT
					number,
					status,
					username
				FROM user WHERE $user ∈ ->request->user`,
			{ user: `user:${user.id}` },
		),
	}
}
