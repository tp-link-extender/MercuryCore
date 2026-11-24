import { type } from "arktype"
import { catalogPage } from "#lib/server/db/catalog.ts"
import { query } from "$app/server"

export const getAssets = query(
	type({
		page: type("number.integer >= 1"),
		type: type.enumerated(2, 8, 11, 12, 13, 18, 19, 32),
	}),
	async args => {
		// The list is already filtered by type, so package contents aren't passed in
		const { assets, pages } = await catalogPage(args)

		// track https://github.com/sveltejs/kit/issues/14398 and https://github.com/sveltejs/kit/issues/14932

		return { assets, pages }
	}
)
