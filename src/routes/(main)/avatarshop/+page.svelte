<script lang="ts">
	import type { PageData, Snapshot } from "./$types"
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
	export const snapshot: Snapshot = {
		capture: () => query,
		restore: v => (query = v),
	}

	export let data: PageData
</script>

<svelte:head>
	<title>Avatar Shop - Mercury</title>
</svelte:head>

<h1 class="light-text text-center">
	Avatar Shop
	<a href="/avatarshop/create" class="btn btn-primary ms-4">Create</a>
</h1>

<div class="container">
	<div class="row">
		<div class="col-lg-4 col-xl-3 mb-4">
			<div class="card rounded-none">
				<div class="card-header light-text px-3 py-2"><i class="fa fa-magnifying-glass" /> Filter</div>
				<div class="card-body">
					<form use:enhance method="POST" action="/search">
						<div class="input-group mb-3">
							<input bind:value={query} type="text" name="query" class="form-control light-text input" placeholder="Search" aria-label="Search" aria-describedby="button-addon2" />
							<input type="hidden" name="category" value="items" />
							<button class="btn btn-success" type="submit" id="button-addon2">Search</button>
						</div>
						<p>
							<a class="text-decoration-none" data-bs-toggle="collapse" href="#collapse" role="button" aria-expanded="false" aria-controls="collapse">
								<b>Advanced</b> <i class="fa fa-circle-chevron-down" />
							</a>
						</p>
						<div class="collapse" id="collapse">
							<div class="mb-3">
								<label for="genre" class="form-label light-text">Type</label>
								<select class="form-select form-select-sm light-text" id="genre" placeholder="Genre" aria-label="genre">
									<option value="Shirts">Shirts</option>
									<option value="Hats">Hats</option>
									<option value="Skirts">Skirts</option>
								</select>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
		<div class="col">
			<div class="container d-grid">
				{#each query ? searchedData : data.items || [] as item, num}
					<Item {item} {num} total={data.items.length} />
				{/each}
				{#if query && searchedData.length == 0}
					<h2 class="h3 light-text mt-5">No items found with search term {query}</h2>
				{/if}
			</div>
		</div>
	</div>
</div>

<style lang="sass">
	.input, select
		background-color: var(--accent)
		border-color: var(--accent2)

	.container
		max-width: 100%

	.d-grid
		width: fit-content
		font-size: 0.9rem

		grid-template-columns: repeat(auto-fit, minmax(10rem, 1fr))
		column-gap: 1.3rem
		row-gap: 1.3rem
		place-items: center
	
	.card
		background: var(--darker)
</style>
