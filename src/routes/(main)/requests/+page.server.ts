import surql from "$lib/surrealtag"
import { authorise } from "$lib/server/lucia"
import { squery } from "$lib/server/surreal"

export async function load({ locals }) {
	const { user } = await authorise(locals)

	return {
		users: squery(
			surql`
				SELECT
					number,
					username
				FROM user WHERE $user ∈ ->request->user`,
			{ user: `user:${user.id}` },
		) as Promise<
			{
				number: number
				username: string
			}[]
		>,
	}
}
