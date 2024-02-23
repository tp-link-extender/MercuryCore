<script lang="ts">
	export let data
</script>

<!--
	Data from the root layout must be passed into the
	Navbar component, as it cannot be accessed directly.
-->
<StudioNavbar {data} />

<main class="py-5vh <lg:pt-2.5vh flex-1">
	<!-- <slot /> -->
	Yeah
</main>

<StudioFooter {data} />
