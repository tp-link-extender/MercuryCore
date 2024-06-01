<script lang="ts">
	import { browser } from "$app/environment"

	export let data

	let query = data.query
	let searchedData: typeof data.assets = []

	// Run function whenever query changes
	// Todo restructure to a GET request
	$: query &&
		browser &&
		(async () => {
			if (query.trim().length === 0) {
				searchedData = data.assets
				return
			}

			const formdata = new FormData()
			formdata.append("q", query)

			const response = await fetch("/inventory", {
				method: "POST",
				body: formdata
			})
			const result = deserialize(await response.text()) as {
				data: {
					assets: typeof data.assets
				}
			}

			searchedData = result.data.assets
		})()

	export const snapshot = {
		capture: () => query,
		restore: v => {
			query = v
		}
	}

	const tabTypes: { [k: string]: number } = {
		Hats: 8,
		"T-Shirts": 2,
		Shirts: 11,
		Pants: 12,
		Decals: 13,
		Faces: 18
	}

	let tabData = TabData(data.url, Object.keys(tabTypes))

	$: assets = (query && browser ? searchedData : data.assets || []).filter(
		a => a.type === tabTypes[tabData.currentTab]
	)
</script>

<Head title="Inventory" />

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
				<fa fa-magnifying-glass />
			</button>
		</form>
		<div
			class="grid gap-4 grid-cols-2 xl:grid-cols-6 md:grid-cols-4 sm:grid-cols-3">
			{#each assets as asset, num}
				<Asset {asset} {num} total={assets.length} />
			{/each}
			{#if query && assets.length === 0}
				<h2 class="text-xs pt-12">
					No items found with search term {query}
				</h2>
			{/if}
		</div>
	</SidebarShell>
</div>
