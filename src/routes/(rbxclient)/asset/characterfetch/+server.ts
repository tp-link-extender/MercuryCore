import { error } from "@sveltejs/kit"

export function GET({ url, setHeaders }) {
	const userId = url.searchParams.get("userID")

	if (!userId || !/^\d+$/.test(userId)) throw error(400, "Invalid Request")

	let charApp = `https://banland.xyz/asset/bodycolors?id=${userId}`

	setHeaders({
		Pragma: "no-cache",
		"Cache-Control": "no-cache",
	})

	return new Response(charApp + ";https://banland.xyz/asset/?id=20573078")
}
