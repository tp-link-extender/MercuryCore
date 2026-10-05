import { error } from "@sveltejs/kit"
import { assetRegex } from "$lib/paramTests"
import config from "$lib/server/config"
import { packageItems } from "$lib/server/packageItems"

export async function GET({ url }) {
	const id = url.searchParams.get("id")
	if (!id || !assetRegex.test(id)) error(400, "Missing id parameter")

	const items = await packageItems(+id, "")

	// default body colours, then every item in the package (nested included)
	let charApp = `http://${config.DomainInsecure}/asset/bodycolors.ashx`
	for (const item of items)
		charApp += `;http://${config.Domain}/asset?id=${item.id}`

	return new Response(charApp, {
		headers: {
			Pragma: "no-cache",
			"Cache-Control": "no-cache",
		},
	})
}
