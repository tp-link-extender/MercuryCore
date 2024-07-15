import { authorise } from "$lib/server/lucia"
import { Record, equery, surql } from "$lib/server/surreal"

export async function load({ locals }) {
	const { user } = await authorise(locals)
	const [users] = await equery<BasicUser[][]>(
		surql`
			SELECT number, status, username
			FROM user WHERE $user IN ->request->user`,
		{ user: Record("user", user.id) }
	)

	return { users }
}
