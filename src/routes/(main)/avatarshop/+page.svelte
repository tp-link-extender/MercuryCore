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

<div class="ctnr">
	<div class="row mb-4">
		<h1 class="col-xl-4 col-lg-4 col-md-3 mb-0">Catalog</h1>
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
						class="form-select form-select-sm light-text pl-4"
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
				</div>
			</form>
		</div>
	</div>
	<div class="row mb-4">
		<h2 class="col-xl-2 col-lg-4 col-md-3 mb-0">Categories</h2>
		<TabNav bind:tabData justify class="col-xl-10 col-lg-8 col-md-9" />
	</div>

	<div class="row">
		<div class="col-xl-2 col-lg-3 mb-2">
			<h2>Filters</h2>
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
		<div class="col-xl-9 col-lg-9">
			<div class="ctnr">
				<div class="row">
					{#each assets as asset, num (asset.id)}
						<Asset {asset} {num} total={data.assets.length} />
					{/each}
					{#if query && assets.length == 0}
						<h2 class="pt-12">
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
