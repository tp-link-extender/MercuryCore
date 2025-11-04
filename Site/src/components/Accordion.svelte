<script lang="ts">
	import { Accordion } from "melt/builders"
	import type { Snippet } from "svelte"
	import type { HTMLAttributes } from "svelte/elements"

	const {
		children,
		...rest
	}: {
		children: Snippet<[Accordion]>
	} & HTMLAttributes<HTMLDivElement> = $props()

	const accordion = new Accordion()
</script>

<div {...accordion.root} {...rest}>
	{@render children(accordion)}
</div>
