import { invalidateAll } from "$app/navigation"
import type { SubmitFunction } from "@sveltejs/kit"

export const refreshComments: SubmitFunction<any, any> =
	() =>
	async ({ result }) => {
		if (result.type === "success") await invalidateAll()
	}
