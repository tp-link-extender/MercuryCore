<script lang="ts">
	import { enhance } from "$app/forms"
	import { page } from "$app/stores"
	import Asset from "$components/Asset.svelte"
	import Head from "$components/Head.svelte"
	import Pagination from "$components/Pagination.svelte"
	import TabData from "$components/TabData"
	import TabNav from "$components/TabNav.svelte"

	export let data

	const tabTypes: { [k: string]: number } = {
		Hats: 8,
		"T-Shirts": 2,
		Shirts: 11,
		Pants: 12,
		Decals: 13,
		Faces: 18
	}

	let tabData = TabData(data.url, Object.keys(tabTypes))

	$: assets = data.assets.filter(a => a.type === tabTypes[tabData.currentTab])
</script>

<Head name={data.siteName} title="Catalog" />

<div class="ctnr light-text">
	<div class="grid lg:grid-cols-[1fr_2fr] md:grid-cols-[1fr_3fr] pb-4">
		<h1>Catalog</h1>
	</div>

	<!-- <div class="grid gap-2 lg:grid-cols-[1fr_5fr] md:(grid-cols-[1fr_4fr] gap-4)"> -->
	<div class="grid">
		<!-- <div>
			<h2>Filters</h2>
			<div class="text-neutral-4 pt-4 pb-2">Sort by</div>
			<div class="grid grid-cols-[1fr_9fr] items-center gap-1">
				<input
					class="form-check-input"
					type="radio"
					name="sort"
					id="bestselling" />
				<label for="bestselling">Best selling</label>
				<input
					class="form-check-input"
					type="radio"
					name="sort"
					id="recent" />
				<label for="recent">Recently created</label>
				<input
					class="form-check-input"
					type="radio"
					name="sort"
					id="official" />
				<label for="official">By {data.siteName}</label>
				<input
					class="form-check-input"
					type="radio"
					name="sort"
					id="highToLow" />
				<label for="highToLow">Price (high to low)</label>
				<input
					class="form-check-input"
					type="radio"
					name="sort"
					id="lowToHigh" />
				<label for="lowToHigh">Price (low to high)</label>
			</div>
			<div class="text-neutral-4 pt-4 pb-2">Price</div>
			<div class="grid grid-cols-[1fr_9fr] items-center gap-1">
				<input
					class="form-check-input"
					type="radio"
					name="price"
					id="any"
					checked />
				<label for="any">Any price</label>
				<input
					class="form-check-input self-start"
					type="radio"
					name="price" />
				<div>
					<input
						class="mb-2"
						type="number"
						min="0"
						max="999"
						placeholder="Minimum price" />
					<input
						class="mb-2"
						type="number"
						min="0"
						max="999"
						placeholder="Maximum price" />
					<button class="btn btn-tertiary btn-sm">Set</button>
				</div>
			</div>
		</div> -->
		<div>
			<TabNav bind:tabData justify class="<sm:hidden" />
			<TabNav bind:tabData vertical class="sm:hidden pb-4" />
			{#if assets.length > 0}
				<div
					class="grid gap-4 grid-cols-2 xl:grid-cols-7 md:grid-cols-6 sm:grid-cols-3">
					{#each assets as asset, num (asset.id)}
						<Asset
							{asset}
							{num}
							total={data.assets.length}
							symbol={data.currencySymbol} />
					{/each}
				</div>
				{#key $page.url}
					<Pagination totalPages={data.pages} />
				{/key}
			{:else}
				<h2 class="pt-12 text-center">
					No assets exist in this category yet.
				</h2>
			{/if}
		</div>
	</div>
</div>
