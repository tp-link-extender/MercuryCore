<script lang="ts">
	import PageTransition from "$lib/components/PageTransition.svelte"

	export let data: any
</script>

<main>
	<PageTransition pathname={data.pathname}>
		<slot />
	</PageTransition>
</main>
