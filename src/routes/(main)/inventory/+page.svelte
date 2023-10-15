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

<h1 class="light-text text-center mb-4">Inventory</h1>

<div class="container">
	<div class="row">
		<div class="col-lg-2 col-md-3">
			<TabNav bind:tabData vertical />
		</div>
		<div class="col-xl-9 col-lg-9">
			<div class="container">
				<form
				use:enhance
				method="POST"
				action="/search?c=assets"
				class="row mb-4">
				<div class="input-group">
					<input
						type="text"
						name="query"
						class="form-control light-text valid"
						placeholder="Search for an item"
						aria-label="Search for an item"
						aria-describedby="button-addon2" />
					<button
						class="btn btn-success"
						aria-label="Search"
						id="button-addon2">
						<i class="fa fa-magnifying-glass" />
					</button>
				</div>
			</form>
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
