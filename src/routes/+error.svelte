<script lang="ts" context="module">
	import { page } from "$app/stores"
	import Footer from "$lib/components/Footer.svelte"
</script>

<svelte:head>
	<title>Error {$page.status} - Mercury</title>
</svelte:head>

<main>
	<div class="container d-flex flex-column justify-content-center align-items-center light-text rounded-4">
		<h1 class="light-text">Error {$page.status}</h1>
		{$page.error?.message}
	</div>
</main>

<Footer />

<style lang="sass">
	main
		padding-bottom: 30vh
		padding-top: 35vh
		flex: 1 0 auto

		div
			background: var(--accent2)
			width: fit-content
			padding: 2rem 5rem
</style>
