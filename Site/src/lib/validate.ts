// client version of $lib/server/validate

// Form components are schema-agnostic, so their fields can't be typed ahead of use
export type DynamicSuperForm =
	// biome-ignore lint/suspicious/noExplicitAny: see above
	import("sveltekit-superforms/client").SuperForm<any>

export { type SuperForm, superForm } from "sveltekit-superforms/client"
