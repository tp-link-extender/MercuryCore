// biome-ignore-all lint/suspicious/noExplicitAny: form components are schema-agnostic, so their fields can't be typed ahead of use

import type { SuperForm } from "sveltekit-superforms/client"

// client version of $lib/server/validate

export type DynamicSuperForm =
	// oxlint-disable-next-line typescript/no-explicit-any
	SuperForm<any>

export type { SuperForm } from "sveltekit-superforms/client"
export { superForm } from "sveltekit-superforms/client"
