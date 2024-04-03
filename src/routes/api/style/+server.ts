import { authorise } from "$lib/server/lucia"

export async function GET({ locals }) {
	const { user } = await authorise(locals)

	return new Response(user.css, {
		headers: {
			"Content-Type": "text/css",
			"Cache-Control": "no-store",
		},
	})
}
