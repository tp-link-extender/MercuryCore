<script lang="ts">
	let query = "",
		searchedData: any[] = []

	// Run function whenever query changes
	$: query &&
		(async () => {
			const formdata = new FormData()
			formdata.append("query", query)

			const response = await fetch("/avatarshop", {
					method: "POST",
					body: formdata,
				}),
				result: any = deserialize(await response.text())

			searchedData = result.data.places
		})()

	// Snapshots allow form values on a page to be restored
	// if the user navigates away and then back again.
	export const snapshot = {
		capture: () => query,
		restore: v => (query = v),
	}

	export let data

	const tabTypes: { [k: string]: number } = {
		"T-Shirts": 2,
		Shirts: 11,
		Hats: 8,
		Pants: 12,
		Decals: 13,
	}

	let tabData = TabData(data.url, Object.keys(tabTypes))

	const assetFilter = (a: { type: number }) =>
		a.type == tabTypes[tabData.currentTab]
</script>

<Head title="Catalog" />

<div class="container">
	<div class="row mb-4">
		<h1 class="col-xl-4 col-lg-4 col-md-3 mb-0 light-text">Catalog</h1>
		<div class="col-xl-8 col-lg-8 col-md-9 mt-2">
			<form
				use:enhance
				method="POST"
				action="/search?c=assets"
				class="row">
				<div class="input-group">
					<input
						bind:value={query}
						type="text"
						name="query"
						class="form-control light-text valid"
						placeholder="Search for an item"
						aria-label="Search for an item"
						aria-describedby="button-addon2" />
					<select
						class="form-select form-select-sm light-text ps-4"
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
						<i class="fa fa-magnifying-glass" />
					</button>
				</div>
			</form>
		</div>
	</div>
	<div class="row mb-4">
		<h1 class="h4 col-xl-2 col-lg-4 col-md-3 mb-0 light-text">
			Categories
		</h1>
		<div class="xl:col-span-10 lg:col-span-8 md:col-span-9">
			<TabNav bind:tabData justify />
		</div>
	</div>

	<div class="row">
		<div class="col-xl-2 col-lg-3 mb-2">
			<h1 class="light-text h3">Filters</h1>
			<p class="light-text mb-0">Sort by:</p>
			<div class="form-check">
				<input
					class="form-check-input"
					type="radio"
					name="filter"
					id="bestsellingRadio" />
				<label
					class="form-check-label light-text"
					for="bestsellingRadio">
					Bestselling
				</label>
			</div>
			<div class="form-check">
				<input
					class="form-check-input"
					type="radio"
					name="filter"
					id="recentlyCreatedRadio" />
				<label
					class="form-check-label light-text"
					for="recentlyCreatedRadio">
					Recently Created
				</label>
			</div>
			<div class="form-check">
				<input
					class="form-check-input"
					type="radio"
					name="filter"
					id="mercuryRadio" />
				<label class="form-check-label light-text" for="mercuryRadio">
					Mercury
				</label>
			</div>
			<p class="light-text mb-0">Price:</p>
			<div class="form-check">
				<input
					class="form-check-input"
					type="radio"
					name="filter"
					id="defaultPriceRadio"
					checked />
				<label
					class="form-check-label light-text"
					for="defaultPriceRadio">
					Any price
				</label>
			</div>
			<div class="form-check">
				<input
					class="form-check-input"
					type="radio"
					name="filter"
					id="customPriceRadio" />
				<input
					class="form-control form-control-sm mb-2"
					type="number"
					min="0"
					max="999"
					placeholder="Minimum price"
					aria-label="Min price" />
				<input
					class="form-control form-control-sm mb-2"
					type="number"
					min="0"
					max="999"
					placeholder="Maximum price"
					aria-label="Max price" />
				<button class="btn btn-success btn-sm">Set</button>
			</div>
			<div class="form-check">
				<input
					class="form-check-input"
					type="radio"
					name="filter"
					id="lowToHighPriceRadio" />
				<label
					class="form-check-label light-text"
					for="lowToHighPriceRadioRadio">
					Price (low to high)
				</label>
			</div>
			<div class="form-check">
				<input
					class="form-check-input"
					type="radio"
					name="filter"
					id="highToLowPricePriceRadio" />
				<label
					class="form-check-label light-text"
					for="highToLowPricePriceRadio">
					Price (high to low)
				</label>
			</div>
		</div>
		<div class="xl:col-span-9 lg:col-span-9">
			<div class="container">
				<div class="row">
					{#each (query ? searchedData : data.assets || []).filter(assetFilter) as asset, num (asset.id)}
						<Asset {asset} {num} total={data.assets.length} />
					{/each}
					{#if query && searchedData.filter(assetFilter).length == 0}
						<h2 class="h5 light-text mt-12">
							No items found with search term {query}
						</h2>
					{/if}
				</div>
			</div>
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
