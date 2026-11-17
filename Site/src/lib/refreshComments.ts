import type { SubmitFunction } from "$app/forms"
import { refreshAll } from "$app/navigation"

export const refreshComments =
	(): ReturnType<SubmitFunction> =>
	async ({ result }) => {
		if (result.type === "success") await refreshAll()
	}
