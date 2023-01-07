<script lang="ts" context="module">
	import { page } from "$app/stores"
	import Footer from "$lib/components/Footer.svelte"
</script>

<svelte:head>
	<title>Error {$page.status} - Mercury</title>
</svelte:head>

<main>
	<div id="all">
		<div class="container d-flex flex-column justify-content-center align-items-center light-text">
			<h1 class="light-text">Error {$page.status}</h1>
			{$page.error?.message}
		</div>
	</div>
</main>

<Footer />

<style lang="sass">
	main
		padding-bottom: 5vh
		padding-top: 10vh
		flex: 1 0 auto

	#all
		padding: 25vh 0
		div
			background: var(--accent2)
			width: fit-content
			padding: 2rem 5rem
			border-radius: 1rem
</style>
