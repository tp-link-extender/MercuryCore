import type { PageServerLoadEvent } from "./$types"

export const load = async ({ params }: PageServerLoadEvent) => ({
	commentId: params.comment,
})
