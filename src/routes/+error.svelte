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

{#if data.bannerText}
	<p id="banner" class="position-fixed top-0 py-1 text-center w-100 text-{data.bannerTextLight ? 'light' : 'text-dark'}" style="background: {data.bannerColour}">
		{data.bannerText}
	</p>
	<br />
{/if}

<main>
	<div class="container d-flex flex-column justify-content-center align-items-center light-text rounded-4">
		<h1 class="light-text">Error {$page.status}</h1>
		{$page.error?.message}
	</div>
</main>

<Footer />

<style lang="sass">
	main
		padding-bottom: 35vh
		padding-top: 35vh
		flex: 1 0 auto
		@media only screen and (max-width: 768px) and (orientation: portrait)
			padding-bottom: 25vh

		div
			background: var(--accent)
			width: fit-content
			padding: 2rem 5rem

	#banner
		margin-top: 5.5vh
		z-index: 1
</style>
