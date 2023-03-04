<script lang="ts">
	// If an error happens in any +page or +layout file,
	// this page will be rendered instead.

	import type { LayoutData } from "./$types"
	import { page } from "$app/stores"
	import Navbar from "$lib/components/Navbar.svelte"
	import Footer from "$lib/components/Footer.svelte"

	export let data: LayoutData
</script>

<svelte:head>
	<title>Error {$page.status} - Mercury</title>
</svelte:head>

<Navbar {data} />

<main>
	<div class="container d-flex flex-column justify-content-center align-items-center light-text rounded-4">
		<h1 class="light-text">Error {$page.status}</h1>
		{$page.error?.message}
	</div>
</main>

<Footer />

<style lang="sass">
	main
		padding-bottom: 32vh
		padding-top: 31vh
		flex: 1 0 auto
		@media only screen and (max-width: 768px) and (orientation: portrait)
			padding-bottom: 25vh

		div
			background: var(--accent)
			width: fit-content
			padding: 2rem 5rem
</style>
