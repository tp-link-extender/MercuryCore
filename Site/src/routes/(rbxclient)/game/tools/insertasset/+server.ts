import { redirect } from "@sveltejs/kit"
import type { RequestEvent } from "./$types"

export function GET({ url }: RequestEvent) {
	redirect(
		302,
		`https://sets.pizzaboxer.xyz/Game/Tools/InsertAsset.ashx${url.search}`
	)
}
