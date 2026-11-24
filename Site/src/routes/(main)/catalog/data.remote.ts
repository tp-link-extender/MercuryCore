import { type } from "arktype"
import { dbQuery } from "#lib/server/db/query.ts"
import { query } from "$app/server"
import type { Asset } from "./+page.server"
import catalogQuery from "./catalog.surql"

export const getAssets = query(
	type({
		page: type("number.integer >= 1"),
		type: type.enumerated(2, 8, 11, 12, 13, 18, 19, 32),
	}),
	async args => {
		const [assets, pages] = await dbQuery<[Asset[], number]>(
			catalogQuery,
			args
		)

		// track https://github.com/sveltejs/kit/issues/14398 and https://github.com/sveltejs/kit/issues/14932

		return { assets, pages }
	}
)
