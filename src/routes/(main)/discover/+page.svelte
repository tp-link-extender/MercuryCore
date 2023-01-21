<script lang="ts">
	import Place from "$lib/components/Place.svelte"
	export let data: any
</script>

<svelte:head>
	<title>Discover - Mercury</title>
</svelte:head>

<h1 class="text-center light-text">Discover</h1>

<div class="container d-grid mt-5">
	{#each Array(50) as _}
		{#each data.places || [] as place}
			<Place {place} />
		{/each}
	{/each}
</div>

<style lang="sass">
	.container
		max-width: 100%
		font-size: 0.9rem

		grid-template-columns: repeat(auto-fit, minmax(10rem, 1fr))
		column-gap: 1rem
		row-gap: 1rem
		place-items: center
</style>
