<script lang="ts">
	export let data
</script>

<div id="bg" class="fixed w-full h-full pointer-events-none" />

<!--
	Data from the root layout must be passed into
	components, as it cannot be accessed directly.
-->
<Navbar {data} />

<main class="py-5vh <lg:pt-2.5vh bg-transparent flex-1 z-1">
	<slot />
</main>

<Footer {data} />

<style lang="stylus">
	#bg
		background linear-gradient(-20deg, #0000 50%, var(--mainaccent) 250%)
</style>
