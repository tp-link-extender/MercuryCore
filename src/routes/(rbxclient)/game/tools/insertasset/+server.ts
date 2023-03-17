import { redirect } from "@sveltejs/kit"

export async function GET({ url }) {
	throw redirect(
		302,
		"https://sets.pizzaboxer.xyz/Game/Tools/InsertAsset.ashx" + url.search
	)
}
