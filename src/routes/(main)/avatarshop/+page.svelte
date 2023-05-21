<script lang="ts">
	import { enhance, deserialize } from "$app/forms"
	import Item from "$lib/components/Item.svelte"
	import { onMount } from "svelte"

	let query = ""
	let rendered = false
	onMount(() => (rendered = true))

	let searchedData: any[] = []

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
	<title>Catalog - Mercury</title>
</svelte:head>

<div class="container">
	<div class="row mb-3">
		<h1 class="col-xl-4 col-lg-4 col-md-3 mb-0 light-text">Catalog</h1>
		<div class="col-xl-8 col-lg-8 col-md-9 mt-2">
			<form use:enhance method="POST" action="/search" class="row">
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
						<option value="Pant">Pants</option>
						<option value="Decal">Decals</option>
					</select>
					<button
						class="btn btn-success"
						type="submit"
						aria-label="Search"
						id="button-addon2">
						<i class="fa fa-magnifying-glass" />
					</button>
				</div>
			</form>
		</div>
	</div>
	
	<div class="row">
		<div class="col-xl-2 col-lg-5 d-flex justify-content-start">
			<div class="card">
				<div class="card-header light-text">Type</div>
				<div class="card-body">
					<a class="btn btn-outline-success" href="/develop">
						<i class="fas fa-plus" />
						Create Asset
					</a>
					<hr class="light-text" />
					<div
						class="nav flex-column nav-pills"
						id="v-pills-tab"
						role="tablist"
						aria-orientation="vertical">
						<button
							class="nav-link active"
							id="v-pills-hats-tab"
							data-bs-toggle="pill"
							data-bs-target="#v-pills-hats"
							type="button"
							role="tab"
							aria-controls="v-pills-hats"
							aria-selected="true">
							Hats
						</button>
						<button
							class="nav-link"
							id="v-pills-t-shirts-tab"
							data-bs-toggle="pill"
							data-bs-target="#v-pills-t-shirts"
							type="button"
							role="tab"
							aria-controls="v-pills-t-shirts"
							aria-selected="false">
							T-Shirts
						</button>
						<button
							class="nav-link"
							id="v-pills-shirts-tab"
							data-bs-toggle="pill"
							data-bs-target="#v-pills-shirts"
							type="button"
							role="tab"
							aria-controls="v-pills-shirts"
							aria-selected="false">
							Shirts
						</button>
						<button
							class="nav-link"
							id="v-pills-pants-tab"
							data-bs-toggle="pill"
							data-bs-target="#v-pills-pants"
							type="button"
							role="tab"
							aria-controls="v-pills-pants"
							aria-selected="false">
							Pants
						</button>
						<button
							class="nav-link"
							id="v-pills-decals-tab"
							data-bs-toggle="pill"
							data-bs-target="#v-pills-decals"
							type="button"
							role="tab"
							aria-controls="v-pills-decals"
							aria-selected="false">
							Decals
						</button>
					</div>
				</div>
			</div>
		</div>
		<div class="col-xl-9 col-lg-7">
			<div class="container">
				<div class="row">
					<div class="col-xl-2 col-lg-3 col-md-3 col-sm-4 col-6 pb-3 px-2 mb-2">
						<div class="card">
							<div class="card-body">
								<img class="card-img-top img-fluid p-2" src="/tShirtTemplate.webp" alt="T-Shirt">

								<h1 class="h5 mt-2 light-text">T-Shirt</h1>
								<h1 class="h6 mt-2 light-text">by <a href="#" class="text-decoration-none">task</a></h1>
								<h1 class="h6 mt-2 text-success"><i class="fas fa-gem" /> Free</h1>
							</div>
						</div>
					</div>
				</div>
				<!-- <div class="tab-content" id="v-pills-tabContent">
					<div class="tab-pane fade show active" id="v-pills-home" role="tabpanel" aria-labelledby="v-pills-home-tab" tabindex="0">...</div>
					<div class="tab-pane fade" id="v-pills-profile" role="tabpanel" aria-labelledby="v-pills-profile-tab" tabindex="0">...</div>
					<div class="tab-pane fade" id="v-pills-disabled" role="tabpanel" aria-labelledby="v-pills-disabled-tab" tabindex="0">...</div>
					<div class="tab-pane fade" id="v-pills-messages" role="tabpanel" aria-labelledby="v-pills-messages-tab" tabindex="0">...</div>
					<div class="tab-pane fade" id="v-pills-settings" role="tabpanel" aria-labelledby="v-pills-settings-tab" tabindex="0">...</div>
				  </div> -->
				{#each query ? searchedData : data.items || [] as item, num (item.id)}
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
</div>

<style lang="sass">
	input, select
		background-color: var(--accent)
		border-color: var(--accent2)

	select
		max-width: 9rem

	.card-header
		background-color: var(--accent2)

	.nav-pills .nav-link
		color: white

	.d-grid
		font-size: 0.9rem

		grid-template-columns: repeat(auto-fit, minmax(10rem, 1fr))
		column-gap: 1.3rem
		row-gap: 1.3rem
		place-items: center
</style>
