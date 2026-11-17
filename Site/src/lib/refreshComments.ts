import type { SubmitFunction } from "$app/forms"
import { invalidateAll } from "$app/navigation"

export const refreshComments =
	(): ReturnType<SubmitFunction> =>
	async ({ result }) => {
		if (result.type === "success") await invalidateAll()
	}
