<script lang="ts">
	import Footer from "$lib/components/Footer.svelte"
	import Navbar from "$lib/components/Navbar.svelte"

	export let data
</script>

<!--
	Data from the root layout must be passed into the Navbar component, as it cannot be accessed directly.
-->
<Navbar {data} />

<main class="py-5vh <lg:pt-2.5vh flex-1">
	<slot />
</main>

<Footer {data} />
