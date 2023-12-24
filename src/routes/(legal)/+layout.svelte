<script lang="ts">
	export let data
</script>

<div id="bg" class="fixed w-100 h-100 pointer-events-none" />

<!--
	Data from the root layout must be passed into the
	Navbar component, as it cannot be accessed directly.
-->
<Navbar {data} />

<main>
	<slot />
</main>

<Footer />

<style lang="stylus">
	main
		// Prevent content from going behind gradient
		z-index 1
		background none

		padding-bottom 5vh
		padding-top 5vh//10vh
		+-lg()
			padding-top 2.5vh

	#bg
		background linear-gradient(-20deg, #0000 50%, var(--mainaccent) 250%)
</style>
