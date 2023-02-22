<script lang="ts">
	import type { LayoutData } from "./$types"
	import PageTransitions from "$lib/components/PageTransitions.svelte"

	export let data: LayoutData
</script>

<!-- Plain pages (login and register) do not have a navbar or footer. -->

<PageTransitions path={data.currentPath}>
	<main>
		<slot />
	</main>
</PageTransitions>
