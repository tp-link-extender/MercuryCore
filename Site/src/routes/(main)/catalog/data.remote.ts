import { type } from "arktype"
import { query } from "$app/server"
import { db } from "$lib/server/surreal"
import type { Asset } from "./+page.server"
import catalogQuery from "./catalog.surql"

export const getAssets = query(
	type({
		type: type.enumerated(2, 8, 11, 12, 13, 18, 19),
		page: type("number.integer >= 1"),
	}),
	async args => {
		const [assets, pages] = await db.query<[Asset[], number]>(
			catalogQuery,
			args
		)

		// track https://github.com/sveltejs/kit/issues/14398 and https://github.com/sveltejs/kit/issues/14932

		return { assets, pages }
	}
)
