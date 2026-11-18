import { prices } from "economy/api"
import { authorise } from "#lib/server/auth.ts"
import type { PageServerLoadEvent } from "./$types"

export async function load({ locals, fetch: f }: PageServerLoadEvent) {
	await authorise(locals, 3)
	const p = await prices(f)
	// the Economy service has no free source variant, so staff creation is charged and the
	// form shows the cost: one unlimited source per asset, plus a package source for packages
	return {
		packageSourcePrice: p.ok ? p.value.packageSourcePrice : 0n,
		unlimitedSourcePrice: p.ok ? p.value.unlimitedSourcePrice : 0n,
	}
}
