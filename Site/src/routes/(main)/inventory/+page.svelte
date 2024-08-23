<script lang="ts">
	import { browser } from "$app/environment"
	import Asset from "$components/Asset.svelte"
	import Head from "$components/Head.svelte"
	import Icon from "$components/Icon.svelte"
	import SidebarShell from "$components/SidebarShell.svelte"
	import TabData from "$components/TabData"

	export let data

	let query = data.query
	let searchedData: typeof data.assets = []

	// Run function whenever query changes
	async function search() {
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
			action="/inventory?tab={tabData.currentTab}"
			class="input-group pb-4">
			<input
				bind:value={query}
				type="text"
				name="q"
				placeholder="Search for an item"
				aria-label="Search for an item"
				aria-describedby="button-addon2" />
			<button
				class="btn btn-secondary"
				aria-label="Search"
				id="button-addon2">
				<Icon icon="search" />
			</button>
		</form>
		<div
			class="grid gap-4 grid-cols-2 xl:grid-cols-6 md:grid-cols-4 sm:grid-cols-3">
			{#each assets as asset, num}
				<Asset
					{asset}
					{num}
					total={assets.length}
					symbol={data.currencySymbol} />
			{/each}
			{#if query && assets.length === 0}
				<h2 class="text-xs pt-12">
					No items found with search term {query}
				</h2>
			{/if}
		</div>
	</SidebarShell>
</div>
