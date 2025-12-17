<script lang="ts">
	import { page } from "$app/state"
	import Asset from "$components/Asset.svelte"
	import Pagination from "$components/Pagination.svelte"
	import { getAssets } from "./data.remote"

	let { data, tabTypes, tabData } = $props()

	function currentPage() {
		const pageQ = page.url.searchParams.get("p") || "1"
		const pp = +pageQ
		return Number.isNaN(pp) ? 1 : Math.round(pp)
	}

	const { assets, pages } = $derived(
		await getAssets({
			page: currentPage(),
			type: tabTypes[tabData.currentTab as keyof typeof tabTypes]
		})
	)
</script>

{#if assets.length > 0}
	<div
		class="grid gap-4 grid-cols-2 xl:grid-cols-7 md:grid-cols-6 sm:grid-cols-3">
		{#each assets as asset, num (asset.id)}
			<Asset
				{asset}
				{num}
				total={assets.length}
				symbol={data.currencySymbol} />
		{/each}
	</div>
	{#key page.url}
		<Pagination totalPages={pages} />
	{/key}
{:else}
	<h2 class="pt-12 text-center">
		No {tabData.currentTab} available.
	</h2>
{/if}
