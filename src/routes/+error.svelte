<script lang="ts">
	// If an error happens in any +page or +layout file,
	// this page will be rendered instead.

	import { page } from "$app/stores"

	export let data: import("./$types").LayoutData
</script>

<svelte:head>
	<title>Error {$page.status} - Mercury</title>
</svelte:head>

<Navbar {data} />

<main>
	<div
		class="container d-flex flex-column justify-content-center align-items-center light-text bg-a rounded-4">
		<h1 class="light-text">Error {$page.status}</h1>
		{$page.error?.message}
	</div>
</main>

<Footer />

<style lang="stylus">
	main
		padding-bottom 32vh
		padding-top 31vh
		flex 1 0 auto
		+-md()
			padding-bottom 25vh

		div
			width fit-content
			padding 2rem 5rem
</style>
