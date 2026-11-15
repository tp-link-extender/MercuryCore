import { prices } from "economy/api"
import type { PageServerLoadEvent } from "./$types"

export const load = async ({ url, fetch: f }: PageServerLoadEvent) => {
	const p = await prices(f)
	const price = p.ok ? p.value.unlimitedSourcePrice : 0n

	return {
		assetType: url.searchParams.get("asset"),
		price,
	}
}
