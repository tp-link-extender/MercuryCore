import { prices } from "economy/api"
import exclude from "$lib/server/exclude"
import type { PageServerLoadEvent } from "./$types"

export async function load({ fetch: f }: PageServerLoadEvent) {
	exclude("Groups")
	const p = await prices(f)
	return {
		price: p.ok ? p.value.groupPrice : 0n,
	}
}
