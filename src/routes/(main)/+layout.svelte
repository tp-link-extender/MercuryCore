<script lang="ts">
	import Navbar from "$lib/components/Navbar.svelte"
	import Footer from "$lib/components/Footer.svelte"

	export let data

</script>

<div id="all">
	<!--
		Data from the root layout must be passed into the
		Navbar component, as it cannot be accessed directly.
	-->
	<Navbar {data} />

	<main>
		<slot />
	</main>

	<Footer />
</div>

<style lang="sass">
	main
		padding-bottom: 5vh
		padding-top: 5vh//10vh
		flex: 1 0 auto
		@media only screen and (max-width: 991px)
			padding-top: 1vh
		
	#all
		display: flex
		flex-direction: column
		height: 100vh
</style>
