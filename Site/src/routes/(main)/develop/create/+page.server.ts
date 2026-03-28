import { getAssetPrice } from "$lib/server/economy"

export async function load({ url }) {
	const price = getAssetPrice()
	return {
		assetType: url.searchParams.get("asset"),
		price,
	}
}
