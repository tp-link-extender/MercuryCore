import { authorise } from "$lib/server/lucia"
import { query, surql } from "$lib/server/surreal"

export const load = async ({ locals }) => ({
	users: await query<BasicUser>(
		surql`
			SELECT number, status, username
			FROM user WHERE $user IN ->request->user`,
		{ user: `user:${(await authorise(locals)).user.id}` }
	),
})
