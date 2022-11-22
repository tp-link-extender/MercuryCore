<script lang="ts">
	import Footer from "$lib/components/Footer.svelte"
</script>

<div>
	<slot />
</div>

<Footer />

<style lang="sass">
	div
		min-height: 70vh
		padding-bottom: 5vh
</style>
