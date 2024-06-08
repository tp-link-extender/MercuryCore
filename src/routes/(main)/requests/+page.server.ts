import { authorise } from "$lib/server/lucia"
import { RecordId, equery, surrealql } from "$lib/server/surreal"

export async function load({ locals }) {
	const { user } = await authorise(locals)
	const [users] = await equery<BasicUser[][]>(
		surrealql`
			SELECT number, status, username
			FROM user WHERE $user IN ->request->user`,
		{ user: new RecordId("user", user.id) }
	)

	return { users }
}
