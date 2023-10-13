import surql from "$lib/surrealtag"
import { squery } from "$lib/server/surreal"

export const load = async () => ({
	assets: squery(surql`
		SELECT
			meta::id(id) AS id,
			name,
			price,
			type
		FROM asset`) as Promise<
		{
			name: string
			price: number
			id: number
			type: string
		}[]
	>,
})

export const actions = {
	default: async ({ request }) => ({
		places: await squery(
			surql`
				SELECT
					meta::id(id) AS id,
					name,
					price,
					type
				FROM asset
				WHERE string::lowercase($query) ∈ string::lowercase(name)`,
			{ query: (await request.formData()).get("query") as string },
		),
	}),
}
