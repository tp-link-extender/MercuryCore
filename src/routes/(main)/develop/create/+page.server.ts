export function load({ request }) {
	return { assettype: new URL(request.url).searchParams.get("asset") }
}
