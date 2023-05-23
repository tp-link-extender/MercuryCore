<script lang="ts">
	import Asset from "$lib/components/Asset.svelte"

	export let data
</script>

<svelte:head>
	<title>Inventory - Mercury</title>
</svelte:head>

<h1 class="light-text text-center">Inventory</h1>

<div class="container mt-5 d-grid">
	{#each data.assets || [] as asset, num}
		<Asset {asset} {num} total={(data.assets || []).length} />
	{/each}
</div>

<style lang="sass">
	.container
		max-width: 100%
		font-size: 0.9rem

		grid-template-columns: repeat(auto-fit, minmax(16rem, 1fr))
		column-gap: 1rem
		row-gap: 1rem
		place-items: center
</style>
