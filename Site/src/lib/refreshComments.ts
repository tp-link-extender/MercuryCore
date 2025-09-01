import type { SubmitFunction } from "@sveltejs/kit"
import { invalidateAll } from "$app/navigation"

export const refreshComments: SubmitFunction<any, any> =
	() =>
	async ({ result }) => {
		if (result.type === "success") await invalidateAll()
	}
