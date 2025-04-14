<script lang="ts">
	import Footer from "$components/Footer.svelte"
	import Navbar from "$components/Navbar.svelte"

	const { data, children } = $props()
</script>

<div id="bg" class="fixed w-full h-full pointer-events-none"></div>

<!--
	Data from the root layout must be passed into components, as it cannot be accessed directly.
-->
<Navbar {data} />

<main class="py-5vh <lg:pt-2.5vh bg-transparent flex-1 z-1">
	{@render children()}
</main>

<Footer {data} />

<style>
	#bg {
		background: linear-gradient(
			-20deg,
			#0c0521 50%,
			var(--mainaccent) 250%
		);
	}
</style>
