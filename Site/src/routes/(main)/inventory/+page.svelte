<script lang="ts">
	import { browser } from "$app/environment"
	import { page } from "$app/stores"
	import Asset from "$components/Asset.svelte"
	import Head from "$components/Head.svelte"
	import Pagination from "$components/Pagination.svelte"
	import SidebarShell from "$components/SidebarShell.svelte"
	import TabData from "$components/TabData"

	export let data

	let query = data.query
	let searchedData: typeof data.assets = []

	// Run function whenever query changes
	async function search() {
		$page.url.searchParams.set("q", query)
		const response = await fetch(`/inventory/search?q=${query}`)
		searchedData = (await response.json()) as typeof data.assets
	}
	$: query && browser && search()

	export const snapshot = {
		capture: () => query,
		restore: v => {
			query = v
		}
	}

	const tabTypes: { [k: string]: number } = Object.freeze({
		Hats: 8,
		"T-Shirts": 2,
		Shirts: 11,
		Pants: 12,
		Decals: 13,
		Faces: 18
	})

	let tabData = TabData(data.url, Object.keys(tabTypes))

	$: assets = (query && browser ? searchedData : data.assets || []).filter(
		a => a.type === tabTypes[tabData.currentTab]
	)
</script>

<Head name={data.siteName} title="Inventory" />

<h1 class="text-center pb-4">Inventory</h1>

<div class="px-4 pt-6">
	<SidebarShell bind:tabData space>
		<form
			on:submit|preventDefault
			action="/inventory"
			class="input-group pb-4">
			<input
				bind:value={query}
				type="text"
				name="q"
				placeholder="Search for an item"
				aria-label="Search for an item"
				aria-describedby="button-addon2" />
			<input type="hidden" name="tab" value={tabData.currentTab} />
			<button
				class="btn btn-secondary"
				aria-label="Search"
				id="button-addon2">
				<fa fa-search />
			</button>
		</form>

		{#if assets.length > 0}
			<div
				class="grid gap-4 grid-cols-2 xl:grid-cols-6 md:grid-cols-4 sm:grid-cols-3">
				{#each assets as asset, num (asset.id)}
					<Asset
						{asset}
						{num}
						total={assets.length}
						symbol={data.currencySymbol} />
				{/each}
			</div>
			{#key $page.url}
				<Pagination totalPages={1} />
			{/key}
		{:else if query}
			<h2 class="pt-12 text-center">
				No items found with search term {query}
			</h2>
		{:else}
			<h2 class="pt-12 text-center">No items found in this category</h2>
		{/if}
	</SidebarShell>
</div>
