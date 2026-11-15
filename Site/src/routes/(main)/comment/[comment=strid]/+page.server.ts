import type { PageServerLoadEvent } from "./$types"

export const load = ({ params }: PageServerLoadEvent) => ({
	commentId: params.comment,
})
