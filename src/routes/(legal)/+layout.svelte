<script lang="ts">
	import Navbar from "$lib/components/Navbar.svelte"
	import Footer from "$lib/components/Footer.svelte"

	export let data: any
</script>

<div id="bg" class="position-fixed w-100 h-100 z-n1" />

<div id="all">
	<Navbar {data} />

	{#if data.bannerText}
		<p id="banner" class="position-fixed top-0 py-1 text-center w-100 text-{data.bannerTextLight ? 'light' : 'text-dark'}" style="background: {data.bannerColour}">
			{data.bannerText}
		</p>
		<br />
	{/if}

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

	#bg
		background: linear-gradient(-20deg, #0000 50%, var(--mainaccent) 250%)

	#banner
		margin-top: 5.5vh
		z-index: 1
</style>
