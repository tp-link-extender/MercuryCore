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
		Faces: 18,
	}

	let tabData = TabData(data.url, Object.keys(tabTypes))

	$: assets = (query && browser ? searchedData : data.assets || []).filter(
		a => a.type == tabTypes[tabData.currentTab]
	)
</script>

<Head title="Inventory" />

<h1 class="text-center pb-4">Inventory</h1>

<div class="ctnr flex flex-wrap">
	<TabNav
		bind:tabData
		vertical
		class="w-full lg:w-1/6 md:w-1/4 pb-6 md:pr-4" />
	<div class="w-full lg:w-5/6 md:w-3/4">
		<form
			on:submit|preventDefault
			action="/inventory?tab={tabData.currentTab}"
			class="input-group pb-4">
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
		</form>
		<div
			class="grid gap-4 grid-cols-2
			xl:grid-cols-6 md:grid-cols-4 sm:grid-cols-3">
			{#each assets as asset, num}
				<Asset {asset} {num} total={assets.length} />
			{/each}
			{#if query && assets.length == 0}
				<h2 class="fs-5 pt-12">
					No items found with search term {query}
				</h2>
			{/if}
		</div>
	</div>
</div>
