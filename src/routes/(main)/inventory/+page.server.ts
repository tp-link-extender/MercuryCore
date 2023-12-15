import { authorise } from "$lib/server/lucia"
import { query, surql } from "$lib/server/surreal"

const select = surql`
	SELECT
		meta::id(id) AS id,
		name,
		price,
		type,
		<-owns<-user AS owners
	FROM asset WHERE $user ∈ <-owns<-user
		AND type ∈ [17, 18, 2, 11, 12, 19] `

export const load = async ({ locals, url }) => {
	const searchQ = url.searchParams.get("q")?.trim()

	return {
		query: searchQ,
		assets: await query<{
			name: string
			price: number
			id: number
			type: number
		}>(
			surql`${select} ${
				searchQ
					? surql`AND string::lowercase($query) ∈ string::lowercase(name)`
					: ""
			}`,
			{
				user: `user:${(await authorise(locals)).user.id}`,
				query: searchQ,
			},
		),
	}
}

export const actions = {
	default: async ({ request, locals }) => ({
		assets: await query(
			surql`${select}
				AND string::lowercase($query) ∈ string::lowercase(name)`,
			{
				query: (await request.formData()).get("q") as string,
				user: `user:${(await authorise(locals)).user.id}`,
			},
		),
	}),
}
