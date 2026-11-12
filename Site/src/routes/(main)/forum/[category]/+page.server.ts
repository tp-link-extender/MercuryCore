import type { PageServerLoadEvent } from "./$types"

export const load = ({ params }: PageServerLoadEvent) => ({
	categoryName: params.category,
})
