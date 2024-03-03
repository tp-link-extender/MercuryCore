<script lang="ts">
	export let data
</script>

<!--
	Data from the root layout must be passed into the
	Navbar component, as it cannot be accessed directly.
-->
<StudioNavbar {data} />

<main class="h-90% bg-darker">
	<!-- <slot /> -->
	Yeah
</main>

<StudioFooter {data} />
