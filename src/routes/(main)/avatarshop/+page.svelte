<script lang="ts">
	import { enhance, deserialize } from "$app/forms"
	import Item from "$lib/components/Item.svelte"
	import { onMount } from "svelte"
	import { Tab, TabNav, TabData } from "$lib/components/Tabs"

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

	let tabData = TabData(data.url, ["Hats", "T-Shirts", "Shirts", "Pants", "Decals"])
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
	<div class="row mb-3">
		<h1 class="h4 col-xl-2 col-lg-4 col-md-3 mb-0 light-text">Categories</h1>
		<div class="col-xl-10 col-lg-8 col-md-9">
			<TabNav bind:tabData justify/>
		</div>
	</div>
	
	<div class="row">
		<div class="col-xl-2 col-lg-5">
			<h1 class="light-text h3">Filters</h1>
			<p class="light-text mb-0">Sort by:</p>
			<a href="/" class="text-decoration-none">Recently Updated</a><br/>
			<a href="/" class="text-decoration-none">Bestselling</a><br/>
			<p class="light-text mb-0">Price:</p>
			<a href="/" class="text-decoration-none">Price (low to high)</a><br/>
			<a href="/" class="text-decoration-none">Price (high to low)</a><br/>
		</div>
		<div class="col-xl-9 col-lg-7">
			<div class="container">
				<div class="row">
					<div class="col-xl-2 col-lg-3 col-md-3 col-sm-4 col-6 pb-3 px-2 mb-2">
					   <div class="card hover-shadow">
						  <div class="card-body">
							 <p class="text-center"><img class="img-fluid" src="https://media.istockphoto.com/photos/traffic-cone-picture-id504567615?k=6&amp;m=504567615&amp;s=170667a&amp;w=0&amp;h=8dg2yif2eSK74tmJOV-b7Gk-976r2Kgo_ytjTTwnORc="></p>
							 <a href="#" class="m-0 text-decoration-none">Traffic Cone</a>
							 <p class="m-0 text-success"><i class="far fa-gem"></i> 2000</p>
						  </div>
					   </div>
					</div>
					<div class="col-xl-2 col-lg-3 col-md-3 col-sm-4 col-6 pb-3 px-2 mb-2">
					   <div class="card hover-shadow">
						  <div class="card-body">
							 <p class="text-center"><img class="img-fluid" src="https://media.istockphoto.com/photos/traffic-cone-picture-id504567615?k=6&amp;m=504567615&amp;s=170667a&amp;w=0&amp;h=8dg2yif2eSK74tmJOV-b7Gk-976r2Kgo_ytjTTwnORc="></p>
							 <a href="#" class="m-0 text-decoration-none">Traffic Cone</a>
							 <p class="m-0 text-success"><i class="far fa-gem"></i> 2000</p>
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
