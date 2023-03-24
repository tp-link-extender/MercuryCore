<script lang="ts">
	import Item from "$lib/components/Item.svelte"

	export let data
</script>

<svelte:head>
	<title>Inventory - Mercury</title>
</svelte:head>

<h1 class="light-text text-center">Inventory</h1>

<div class="container mt-5 d-grid">
	{#each data.items || [] as item, num}
		<Item {item} {num} total={(data.items || []).length} />
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
