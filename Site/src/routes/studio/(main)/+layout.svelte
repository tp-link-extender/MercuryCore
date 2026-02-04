<script lang="ts">
	import StudioNavbar from "$components/StudioNavbar.svelte"
	import StudioFooter from "$components/StudioFooter.svelte"

	const { data } = $props()
</script>

<!--
	Data from the root layout must be passed into the
	Navbar component, as it cannot be accessed directly.
-->
<StudioNavbar {data} />

<main class="bg-darker h-90%">
	<!-- <slot /> -->
	Yeah
</main>

<StudioFooter {data} />
