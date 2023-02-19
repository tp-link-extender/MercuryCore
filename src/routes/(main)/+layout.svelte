<script lang="ts">
	import type { LayoutData } from "./$types"
	import Navbar from "$lib/components/Navbar.svelte"
	import Footer from "$lib/components/Footer.svelte"

	export let data: LayoutData
</script>

<div id="all">
	<Navbar {data} />

	<main>
		<slot />
	</main>

	<Footer />
</div>

<style lang="sass">
	main
		padding-bottom: 5vh
		padding-top: 10vh
		flex: 1 0 auto
		
	#all
		display: flex
		flex-direction: column
		height: 100vh
</style>
