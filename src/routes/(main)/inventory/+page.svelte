<script lang="ts">
	export let data

	let tabData = TabData(data.url, [
		"Hats",
		"T-Shirts",
		"Shirts",
		"Pants",
		"Decals",
	])
</script>

<Head title="Inventory" />

<h1 class="light-text text-center">Inventory</h1>

<div class="container">
	<div class="row">
		<div class="col-lg-2 col-md-3">
			<TabNav bind:tabData vertical tabs />
		</div>
		<div class="col-xl-9 col-lg-9">
			<div class="container">
				<div class="row">
					{#each data.assets || [] as asset, num}
						<Asset
							{asset}
							{num}
							total={(data.assets || []).length} />
					{/each}
				</div>
			</div>
		</div>
	</div>
</div>

<!-- <div class="container mt-12 d-grid">
	{#each data.assets || [] as asset, num}
		<Asset {asset} {num} total={(data.assets || []).length} />
	{/each}
</div> -->

<style lang="stylus">

</style>
