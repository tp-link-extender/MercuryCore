import type { PageServerLoadEvent } from "./$types"

export const load = async ({ params }: PageServerLoadEvent) => ({
	categoryName: params.category,
})
