import { redirect } from "@sveltejs/kit"
import type { RequestHandler } from "./$types"

export const GET: RequestHandler = async ({ url }) => {
	throw redirect(302, `/asset/assetfetch?id=${url.searchParams.get("id")}`)
}
