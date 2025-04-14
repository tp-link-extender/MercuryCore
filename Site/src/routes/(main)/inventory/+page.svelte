<script lang="ts">
	import { page } from "$app/state"
	import Asset from "$components/Asset.svelte"
	import Head from "$components/Head.svelte"
	import Pagination from "$components/Pagination.svelte"
	import SidebarShell from "$components/SidebarShell.svelte"
	import TabData from "$components/TabData"

	const { data } = $props()

	const tabTypes: { [k: string]: number } = Object.freeze({
		Hats: 8,
		"T-Shirts": 2,
		Shirts: 11,
		Pants: 12,
		Decals: 13,
		Faces: 18
	})

	let tabData = $state(TabData(data.url, Object.keys(tabTypes)))

	let assets = $derived(
		data.assets.filter(a => a.type === tabTypes[tabData.currentTab])
	)
</script>

<Head name={data.siteName} title="Inventory" />

<h1 class="text-center pb-4">Inventory</h1>

<div class="px-4 pt-6">
	<SidebarShell bind:tabData space>
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
			{#key page.url}
				<Pagination totalPages={data.pages} />
			{/key}
		{:else}
			<h2 class="pt-12 text-center">
				You don't have any {tabData.currentTab} yet.
			</h2>
			<h3 class="pt-4 text-center">
				Head to the
				<!--
					?tab= works questionably due to url/local state mismatch...
					eh, I signed up for that	
				-->
				<a href="/catalog?tab={tabData.currentTab}">Catalog</a>
				to get some!
			</h3>
		{/if}
	</SidebarShell>
</div>
