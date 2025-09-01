<script lang="ts">
	import { type createAccordion, melt } from "@melt-ui/svelte"
	import type { Snippet } from "svelte"
	import type { HTMLAttributes } from "svelte/elements"
	import NoScript from "$components/NoScript.svelte"
	import YesScript from "$components/YesScript.svelte"

	const {
		accordion,
		children,
		...rest
	}: {
		accordion: ReturnType<typeof createAccordion>
		children: Snippet
	} & HTMLAttributes<HTMLDivElement> = $props()

	const {
		elements: { root }
	} = accordion
</script>

<NoScript>
	<div {...rest}>
		{@render children()}
	</div>
</NoScript>
<YesScript>
	<div use:melt={$root} {...rest}>
		{@render children()}
	</div>
</YesScript>
