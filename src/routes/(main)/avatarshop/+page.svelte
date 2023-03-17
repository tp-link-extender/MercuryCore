<script lang="ts">
	import { enhance, deserialize } from "$app/forms"
	import Item from "$lib/components/Item.svelte"
	import { onMount } from "svelte"

	let query = ""
	let rendered = false
	onMount(() => (rendered = true))

	let searchedData: any = []

	// Run function whenever query changes
	$: (query || rendered) &&
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
</script>

<svelte:head>
	<title>Avatar Shop - Mercury</title>
</svelte:head>

<div class="container">
	<div class="row mb-5">
		<h1 class="col light-text">
			Avatar Shop
			<a href="/avatarshop/create" class="btn btn-primary ms-4">Create</a>
		</h1>
		<div class="col-8">
			<form use:enhance method="POST" action="/search" class="row">
				<div class="col-8 ms-auto me-5">
					<div class="input-group">
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
						</select>
						<button
							class="btn btn-success"
							type="submit"
							id="button-addon2">
							<i class="fa fa-magnifying-glass" />
						</button>
					</div>
				</div>
			</form>
		</div>
	</div>
	<div class="row">
		<div class="container d-grid m-0">
			{#each query ? searchedData : data.items || [] as item, num}
				<Item {item} {num} total={data.items.length} />
			{/each}
			{#if query && searchedData.length == 0}
				<h2 class="h5 light-text mt-5">
					No items found with search term {query}
				</h2>
			{/if}
		</div>
	</div>
</div>

<style lang="sass">
	input, select
		background-color: var(--accent)
		border-color: var(--accent2)

	select
		max-width: 9rem

	.d-grid
		width: fit-content
		font-size: 0.9rem

		grid-template-columns: repeat(auto-fit, minmax(10rem, 1fr))
		column-gap: 1.3rem
		row-gap: 1.3rem
		place-items: center
</style>
