import surql from "$lib/surrealtag"
import { authorise } from "$lib/server/lucia"
import { query } from "$lib/server/surreal"

export const load = async ({ locals }) => ({
	assets: query<{
		name: string
		price: number
		id: number
		type: string
		creator: {
			number: number
			username: string
		}
		imageAsset?: {
			id: number
			name: string
		}
	}>(
		surql`
			SELECT
				meta::id(id) AS id,
				name,
				price,
				type,
				(SELECT number, username
				FROM <-created<-user)[0] AS creator,
				(SELECT meta::id(id) AS id, name
				FROM ->imageAsset->asset)[0] AS imageAsset
			FROM asset WHERE visibility = "Pending"
				AND type ∈ [17, 18, 2, 11, 12, 19]`,
		{ user: `user:${(await authorise(locals)).user.id}` },
	),
})

