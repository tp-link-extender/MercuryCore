import { authorise } from "#lib/server/auth.ts"
import { allBanners } from "#lib/server/db/banners.ts"
import type { PageServerLoadEvent } from "./$types"

export async function load({ locals }: PageServerLoadEvent) {
	await authorise(locals, 5)

	const banners = await allBanners()
	return { banners }
}
