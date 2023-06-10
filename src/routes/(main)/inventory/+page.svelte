<script lang="ts">
	import Asset from "$lib/components/Asset.svelte"

	export let data
</script>

<svelte:head>
	<title>Inventory - Mercury</title>
</svelte:head>

<h1 class="light-text text-center">Inventory</h1>

<div class="mx-auto grid grid-cols-12 gap-6">
	{#each data.assets || [] as asset, num}
		<Asset {asset} {num} total={(data.assets || []).length} />
	{/each}
</div>

<style lang="sass">
	div
		max-width: 70rem
		font-size: 0.9rem
</style>
