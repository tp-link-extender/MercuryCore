<script lang="ts">
	import NoScript from "$components/NoScript.svelte"
	import YesScript from "$components/YesScript.svelte"
	import { createAccordion, melt } from "@melt-ui/svelte"
	import type { Snippet } from "svelte"

	const {
		accordion = createAccordion(),
		children
	}: {
		accordion: ReturnType<typeof createAccordion>
		children: Snippet
	} = $props()

	const {
		elements: { root }
	} = accordion
</script>

<NoScript>
	 {@render children()}
</NoScript>
<YesScript>
	<div use:melt={$root}>
		 {@render children()}
	</div>
</YesScript>
