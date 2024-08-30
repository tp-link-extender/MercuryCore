<script lang="ts">
	import { page } from "$app/stores"
	import Asset from "$components/Asset.svelte"
	import Head from "$components/Head.svelte"
	import Pagination from "$components/Pagination.svelte"
	import SidebarShell from "$components/SidebarShell.svelte"
	import TabData from "$components/TabData"

	export let data

	const tabTypes: { [k: string]: number } = Object.freeze({
		Hats: 8,
		"T-Shirts": 2,
		Shirts: 11,
		Pants: 12,
		Decals: 13,
		Faces: 18
	})

	let tabData = TabData(data.url, Object.keys(tabTypes))

	$: assets = data.assets.filter(a => a.type === tabTypes[tabData.currentTab])
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
			{#key $page.url}
				<Pagination totalPages={1} />
			{/key}
		{:else}
			<h2 class="pt-12 text-center">No {tabData.currentTab} found</h2>
		{/if}
	</SidebarShell>
</div>
