import { authorise } from "$lib/server/lucia"
import { query, surql } from "$lib/server/surreal"

type Users = {
	number: number
	status: "Playing" | "Online" | "Offline"
	username: string
}
export const load = async ({ locals }) => ({
	users: await query<Users>(
		surql`
			SELECT number, status, username
			FROM user WHERE $user ∈ ->request->user`,
		{ user: `user:${(await authorise(locals)).user.id}` }
	),
})
