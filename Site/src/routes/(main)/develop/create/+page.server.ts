import { prices } from "economy/api"
import type { PageServerLoadEvent } from "./$types"

export const load = async ({ url, fetch: f }: PageServerLoadEvent) => {
	const p = await prices(f)
	// creating an asset makes two sources, one for the image and one for the asset itself.
	// both are charged, so the shown price has to cover both
	const price = p.ok ? p.value.unlimitedSourcePrice * 2n : 0n

	return {
		assetType: url.searchParams.get("asset"),
		price,
	}
}
