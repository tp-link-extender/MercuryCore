<script lang="ts">
	import { Accordion } from "melt/builders"
	import type { Snippet } from "svelte"
	import type { HTMLAttributes } from "svelte/elements"
	import NoScript from "$components/NoScript.svelte"
	import YesScript from "$components/YesScript.svelte"

	const {
		children,
		...rest
	}: {
		children: Snippet<[Accordion]>
	} & HTMLAttributes<HTMLDivElement> = $props()

	const accordion = new Accordion()
</script>

<NoScript>
	<div {...rest}>
		{@render children(accordion)}
	</div>
</NoScript>
<YesScript>
	<div {...accordion.root} {...rest}>
		{@render children(accordion)}
	</div>
</YesScript>
