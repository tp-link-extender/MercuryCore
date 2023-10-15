import surql from "$lib/surrealtag"
import { query } from "$lib/server/surreal"

export const load = async () => ({
	assets: query<{
		name: string
		price: number
		id: number
		type: number
	}>(surql`
		SELECT
			meta::id(id) AS id,
			name,
			price,
			type
		FROM asset WHERE visibility = "Visible"`),
})

export const actions = {
	default: async ({ request }) => ({
		assets: await query(
			surql`
				SELECT
					meta::id(id) AS id,
					name,
					price,
					type
				FROM asset
				WHERE string::lowercase($query) ∈ string::lowercase(name)`,
			{ query: (await request.formData()).get("q") as string },
		),
	}),
}
