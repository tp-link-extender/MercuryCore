import surql from "$lib/surrealtag"
import { authorise } from "$lib/server/lucia"
import { query } from "$lib/server/surreal"

export const load = async ({ locals }) => ({
	assets: query<{
		name: string
		price: number
		id: number
		type: string
	}>(
		surql`
			SELECT
				meta::id(id) AS id,
				name,
				price,
				type,
				<-owns<-user AS owners
			FROM asset WHERE $user ∈ <-owns<-user
				AND type ∈ [17, 18, 2, 11, 12, 19]`,
		{ user: `user:${(await authorise(locals)).user.id}` },
	),
})
