<script lang="ts">
	export let data

	let query = "",
		searchedData: typeof data.assets = []

	// Run function whenever query changes
	$: query &&
		(async () => {
			const formdata = new FormData()
			formdata.append("q", query)

			const response = await fetch("/avatarshop", {
				method: "POST",
				body: formdata,
			})
			const result: any = deserialize(await response.text())

			searchedData = result.data.assets
		})()

	export const snapshot = {
		capture: () => query,
		restore: v => (query = v),
	}

	const tabTypes: { [k: string]: number } = {
		"T-Shirts": 2,
		Shirts: 11,
		Hats: 8,
		Pants: 12,
		Decals: 13,
		Faces: 18,
	}

	let tabData = TabData(data.url, Object.keys(tabTypes))

	$: assets = (query ? searchedData : data.assets || []).filter(
		a => a.type == tabTypes[tabData.currentTab]
	)
</script>

<Head title="Catalog" />

<div class="ctnr light-text">
	<div class="flex flex-wrap pb-4">
		<h1 class="w-full lg:w-1/3 md:w-1/4 mb-0">Catalog</h1>
		<div class="w-full lg:w-2/3 md:w-3/4 pt-2">
			<form
				use:enhance
				method="POST"
				action="/search?c=assets"
				class="input-group">
				<input
					bind:value={query}
					type="text"
					name="query"
					placeholder="Search for an item"
					aria-label="Search for an item"
					aria-describedby="button-addon2" />
				<select
					class="form-select pl-4"
					placeholder="Type"
					aria-label="Type">
					<option value="Shirt">Shirts</option>
					<option value="TShirt">T-Shirts</option>
					<option value="Hat">Hats</option>
					<option value="Pant">Pants</option>
					<option value="Decal">Decals</option>
				</select>
				<button
					class="btn btn-success"
					aria-label="Search"
					id="button-addon2">
					<fa fa-magnifying-glass />
				</button>
			</form>
		</div>
	</div>

	<div class="flex flex-wrap">
		<div class="w-full xl:w-1/6 lg:w-1/4 pb-2 md:pr-4">
			<h2 class="pb-4">Categories</h2>
			<h2>Filters</h2>
			<p>Sort by:</p>
			<div>
				<input
					class="form-check-input"
					type="radio"
					name="sort"
					id="bestselling" />
				<label for="bestselling">Bestselling</label>
			</div>
			<div>
				<input
					class="form-check-input"
					type="radio"
					name="sort"
					id="recentlyCreated" />
				<label for="recentlyCreated">Recently Created</label>
			</div>
			<div>
				<input
					class="form-check-input"
					type="radio"
					name="sort"
					id="mercury" />
				<label for="mercury">Mercury</label>
			</div>
			<div>
				<input
					class="form-check-input"
					type="radio"
					name="sort"
					id="highToLow" />
				<label for="highToLow">Price (high to low)</label>
			</div>
			<div>
				<input
					class="form-check-input"
					type="radio"
					name="sort"
					id="lowToHigh" />
				<label for="lowToHigh">Price (low to high)</label>
			</div>
			<p>Price:</p>
			<div>
				<input
					class="form-check-input"
					type="radio"
					name="price"
					id="any"
					checked />
				<label for="any">Any price</label>
			</div>
			<div>
				<input class="form-check-input" type="radio" name="price" />
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
				<button class="btn btn-success btn-sm">Set</button>
			</div>
		</div>
		<div class="w-full xl:w-5/6 lg:w-3/4">
			<TabNav bind:tabData justify />
			{#if !query || assets.length > 0}
				<div
					class="grid gap-4 grid-cols-2
					xl:grid-cols-6 md:grid-cols-4 sm:grid-cols-3">
					{#each assets as asset, num (asset.id)}
						<Asset {asset} {num} total={data.assets.length} />
					{/each}
				</div>
			{:else}
				<h2 class="pt-12">
					No items found with search term {query}
				</h2>
			{/if}
		</div>
	</div>
</div>

<style lang="stylus">
	input
	select
		background-color var(--accent)
		border-color var(--accent2)

	select
		max-width 9rem
</style>
