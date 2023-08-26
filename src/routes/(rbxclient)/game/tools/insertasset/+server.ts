import { redirect } from "@sveltejs/kit"

export function GET({ url }) {
	throw redirect(
		302,
		"https://sets.pizzaboxer.xyz/Game/Tools/InsertAsset.ashx" + url.search,
	)
}
