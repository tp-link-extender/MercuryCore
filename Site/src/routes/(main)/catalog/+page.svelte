<script lang="ts">
	import Head from "$components/Head.svelte"
	import TabData from "$components/TabData"
	import TabNav from "$components/TabNav.svelte"
	import Assets from "./Assets.svelte"

	const tabTypes = {
		Hats: 8,
		"T-Shirts": 2,
		Shirts: 11,
		Pants: 12,
		Decals: 13,
		Faces: 18,
		Gear: 19
	} as const

	const { data } = $props()

	let tabData = $state(TabData(data.url, Object.keys(tabTypes)))
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
			<div class="text-neutral-400 pt-4 pb-2">Sort by</div>
			<div class="grid grid-cols-[1fr_9fr] items-center gap-1">
				<input
					type="radio"
					name="sort"
					id="bestselling" />
				<label for="bestselling">Best selling</label>
				<input
					type="radio"
					name="sort"
					id="recent" />
				<label for="recent">Recently created</label>
				<input
					type="radio"
					name="sort"
					id="official" />
				<label for="official">By {data.siteName}</label>
				<input
					type="radio"
					name="sort"
					id="highToLow" />
				<label for="highToLow">Price (high to low)</label>
				<input
					type="radio"
					name="sort"
					id="lowToHigh" />
				<label for="lowToHigh">Price (low to high)</label>
			</div>
			<div class="text-neutral-400 pt-4 pb-2">Price</div>
			<div class="grid grid-cols-[1fr_9fr] items-center gap-1">
				<input
					type="radio"
					name="price"
					id="any"
					checked />
				<label for="any">Any price</label>
				<input
					class="self-start"
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

			<svelte:boundary>
				<Assets {data} {tabTypes} {tabData} />

				{#snippet failed(_, reset)}
					<div class="text-center">
						<p class="text-red-600 pt-12 pb-2">
							An error occurred while loading the assets.
						</p>
						<button class="btn btn-tertiary btn-sm" onclick={reset}>
							Retry
						</button>
					</div>
				{/snippet}
			</svelte:boundary>
		</div>
	</div>
</div>
