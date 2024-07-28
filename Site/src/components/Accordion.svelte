<script lang="ts">
	import NoScript from "$components/NoScript.svelte"
	import YesScript from "$components/YesScript.svelte"
	import { createAccordion, melt } from "@melt-ui/svelte"

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
