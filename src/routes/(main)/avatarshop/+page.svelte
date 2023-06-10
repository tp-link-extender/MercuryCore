<script lang="ts">
	import { enhance, deserialize } from "$app/forms"
	import Asset from "$lib/components/Asset.svelte"
	import { Tab, TabNav, TabData } from "$lib/components/Tabs"

	let query = ""

	let searchedData: any[] = []

	// Run function whenever query changes
	$: query &&
		(async () => {
			const formdata = new FormData()
			formdata.append("query", query)

			const response = await fetch("/avatarshop", {
				method: "POST",
				body: formdata,
			})

			const result: any = deserialize(await response.text())
			searchedData = result.data.places
		})()

	// Snapshots allow form values on a page to be restored
	// if the user navigates away and then back again.
	export const snapshot = {
		capture: () => query,
		restore: v => (query = v),
	}

	export let data

	let tabData = TabData(data.url, [
		"Hats",
		"T-Shirts",
		"Shirts",
		"Pants",
		"Decals",
	])
</script>

<svelte:head>
	<title>Catalog - Mercury</title>
</svelte:head>

<div class="container">
	<div class="grid grid-cols-12 gap-6 mb-3">
		<h1 class="xl:col-span-4 lg:col-span-4 md:col-span-3 mb-0 light-text">
			Catalog
		</h1>
		<div class="xl:col-span-8 lg:col-span-8 md:col-span-9 mt-2">
			<form
				use:enhance
				method="POST"
				action="/search"
				class="grid grid-cols-12 gap-6">
				<div class="flex">
					<input
						bind:value={query}
						type="text"
						name="query"
						class="form-control light-text valid"
						placeholder="Search for an item"
						aria-label="Search for an item"
						aria-describedby="button-addon2" />
					<input type="hidden" name="category" value="items" />
					<select
						class="form-select form-select-sm light-text ps-3"
						placeholder="Type"
						aria-label="Type">
						<option value="Shirt">Shirts</option>
						<option value="TShirt">T-Shirts</option>
						<option value="Hat">Hats</option>
						<option value="Pant">Pants</option>
						<option value="Decal">Decals</option>
					</select>
					<button
						class="btn bg-emerald-600 hover:bg-emerald-800 text-white"
						type="submit"
						aria-label="Search"
						id="button-addon2">
						<i class="fa fa-magnifying-glass" />
					</button>
				</div>
			</form>
		</div>
	</div>
	<div class="grid grid-cols-12 gap-6 mb-3">
		<h1
			class="h4 xl:col-span-2 lg:col-span-4 md:col-span-3 mb-0 light-text">
			Categories
		</h1>
		<div class="xl:col-span-10 lg:col-span-8 md:col-span-9">
			<TabNav bind:tabData justify />
		</div>
	</div>

	<div class="grid grid-cols-12 gap-6">
		<div class="xl:col-span-2 lg:col-span-3">
			<h1 class="light-text h3">Filters</h1>
			<p class="light-text mb-0">Sort by:</p>
			<a href="/" class="no-underline">Recently Updated</a>
			<br />
			<a href="/" class="no-underline">Bestselling</a>
			<br />
			<p class="light-text mb-0">Price:</p>
			<a href="/" class="no-underline">Price (low to high)</a>
			<br />
			<a href="/" class="no-underline">Price (high to low)</a>
			<br />
		</div>
		<div class="xl:col-span-9 lg:col-span-9">
			<div class="container">
				<div class="grid grid-cols-12 gap-6">
					{#each query ? searchedData : data.assets || [] as asset, num (asset.id)}
						<Asset {asset} {num} total={data.assets.length} />
					{/each}
					{#if query && searchedData.length == 0}
						<h2 class="h5 light-text mt-5">
							No items found with search term {query}
						</h2>
					{/if}
				</div>
			</div>
		</div>
	</div>
</div>

<style lang="sass">
	input, select
		background-color: var(--accent)
		border-color: var(--accent2)

	select
		max-width: 9rem
</style>
