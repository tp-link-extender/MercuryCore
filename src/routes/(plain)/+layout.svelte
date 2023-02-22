<<<<<<< HEAD
<script lang="ts">
	import PageTransition from "$lib/components/PageTransition.svelte"

	export let data: any
</script>
=======
<!--
	Plain pages (login and register) do not have a navbar or footer.
-->
>>>>>>> dev

<main>
	<PageTransition pathname={data.pathname}>
		<slot />
	</PageTransition>
</main>
