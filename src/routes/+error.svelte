<script lang="ts">
	// If an error happens in any +page or +layout file,
	// this page will be rendered instead.

	import { page } from "$app/stores"
	import Navbar from "$lib/components/Navbar.svelte"
	import Footer from "$lib/components/Footer.svelte"

	export let data: import("./$types").LayoutData
</script>

<template lang="pug">
	svelte:head
		title Error {$page.status} - Mercury

	Navbar({data})

	main
		.container.d-flex.flex-column.justify-content-center.align-items-center.light-text.bg-a.rounded-4
			h1.light-text Error {$page.status}
			| {$page.error?.message}

	Footer
</template>

<style lang="sass">
	main
		padding-bottom: 32vh
		padding-top: 31vh
		flex: 1 0 auto
		@media only screen and (max-width: 768px) and (orientation: portrait)
			padding-bottom: 25vh

		div
			width: fit-content
			padding: 2rem 5rem
</style>
