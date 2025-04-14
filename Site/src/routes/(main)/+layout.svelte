<script lang="ts">
	import Footer from "$components/Footer.svelte"
	import Navbar from "$components/Navbar.svelte"

	const { data, children } = $props()
</script>

<!--
	Data from the root layout must be passed into the Navbar component, as it cannot be accessed directly.
-->
<Navbar {data} />

<main class="py-5vh <lg:pt-2.5vh flex-1">
	{@render children?.()}
</main>

<Footer {data} />
