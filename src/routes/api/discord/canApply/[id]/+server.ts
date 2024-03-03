import { verify, canApply } from "../../discord"

export async function GET({ url, params }) {
	verify(url)
	// Check if user can apply
	return new Response((await canApply(parseInt(params.id))).toString())
}
