<script lang="ts">
	import PageTransition from "$lib/components/PageTransition.svelte"
	import Navbar from "$lib/components/Navbar.svelte"
	import Footer from "$lib/components/Footer.svelte"

	export let data: any
</script>

<Navbar />

<main>
	<PageTransition pathname={data.pathname}>
		<slot />
	</PageTransition>
</main>

<Footer />

<style lang="sass">
	main
		padding-bottom: 5vh
		padding-top: 10vh
		flex: 1 0 auto
</style>
