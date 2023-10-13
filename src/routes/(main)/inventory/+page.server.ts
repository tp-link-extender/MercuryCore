import surql from "$lib/surrealtag"
import { authorise } from "$lib/server/lucia"
import { squery } from "$lib/server/surreal"

export const load = async ({ locals }) => ({
	assets: squery(
		surql`
			SELECT
				meta::id(id) AS id,
				name,
				price,
				type,
				<-owns<-user AS owners
			FROM asset WHERE $user ∈ <-owns<-user`,
		{ user: `user:${(await authorise(locals)).user.id}` },
	) as Promise<
		{
			name: string
			price: number
			id: number
			type: string
		}[]
	>,
})
