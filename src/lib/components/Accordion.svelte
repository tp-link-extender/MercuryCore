<script lang="ts">
	import { createAccordion, melt } from "@melt-ui/svelte"
	import NoScript from "./NoScript.svelte"
	import YesScript from "./YesScript.svelte"

	export let accordion = createAccordion()

	const {
		elements: { root }
	} = accordion
</script>

<NoScript>
	<slot />
</NoScript>
<YesScript>
	<div use:melt={$root}>
		<slot />
	</div>
</YesScript>
