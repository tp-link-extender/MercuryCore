<script lang="ts">
	export let data
</script>

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
		padding-bottom 5vh
		padding-top 5vh //10vh
		flex 1 0 auto
		+-lg()
			padding-top 2.5vh
</style>
