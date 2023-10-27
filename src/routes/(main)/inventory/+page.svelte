<script lang="ts">
	import { browser } from "$app/environment"

	export let data

	let query = data.query,
		searchedData: typeof data.assets = []

	// Run function whenever query changes
	$: query &&
		browser &&
		(async () => {
			if (query.trim().length < 1) return (searchedData = data.assets)

			const formdata = new FormData()
			formdata.append("q", query)

			const response = await fetch("/inventory", {
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
	}

	let tabData = TabData(data.url, Object.keys(tabTypes))

	$: assets = (query && browser ? searchedData : data.assets || []).filter(
		a => a.type == tabTypes[tabData.currentTab]
	)
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
					on:submit|preventDefault
					action="/inventory?tab={tabData.currentTab}"
					class="row mb-4">
					<div class="input-group">
						<input
							bind:value={query}
							type="text"
							name="q"
							class="form-control light-text valid"
							placeholder="Search for an item"
							aria-label="Search for an item"
							aria-describedby="button-addon2" />
						<button
							class="btn btn-success"
							aria-label="Search"
							id="button-addon2">
							<fa fa-magnifying-glass />
						</button>
					</div>
				</form>
				<div class="row px-1">
					{#each assets as asset, num}
						<Asset {asset} {num} total={assets.length} />
					{/each}
					{#if query && assets.length == 0}
						<h2 class="fs-5 light-text pt-12">
							No items found with search term {query}
						</h2>
					{/if}
				</div>
			</div>
		</div>
	</div>
</div>

<style lang="stylus">

</style>
