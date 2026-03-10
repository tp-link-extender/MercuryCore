import type { SubmitFunction } from "@sveltejs/kit"
import { invalidateAll } from "$app/navigation"

export const refreshComments =
	(): ReturnType<SubmitFunction> =>
	async ({ result }) => {
		if (result.type === "success") await invalidateAll()
	}
