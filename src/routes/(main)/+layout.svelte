<script lang="ts">
	import Navbar from "$lib/components/Navbar.svelte"
	import Footer from "$lib/components/Footer.svelte"
</script>

<Navbar />

<main>
	<slot />
</main>

<Footer />

<style lang="sass">
	main
		padding-bottom: 5vh
		padding-top: 10vh
		flex: 1 0 auto
</style>
