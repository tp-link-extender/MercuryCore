<script lang="ts">
	import type { PageData, Snapshot } from "./$types"
	import { enhance } from "$app/forms"
	import Item from "$lib/components/Item.svelte"

	let value = ""

	export const snapshot: Snapshot = {
		capture: () => value,
		restore: v => (value = v),
	}

	export let data: PageData
</script>

<svelte:head>
	<title>Avatar Shop - Mercury</title>
</svelte:head>

<h1 class="light-text text-center">Avatar Shop</h1>

<div class="container">
	<div class="row">
		<div class="col-lg-4 col-xl-3 mb-4">
			<div class="card rounded-none">
				<div class="card-header light-text px-3 py-2"><i class="fa fa-magnifying-glass" /> Filter</div>
				<div class="card-body">
					<form use:enhance method="POST" action="/search">
						<div class="input-group mb-3">
							<input bind:value type="text" name="query" class="form-control light-text input" placeholder="Search" aria-label="Search" aria-describedby="button-addon2" />
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
				{#each data.items || [] as item}
					<Item {item} />
				{/each}
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
		font-size: 0.9rem

		grid-template-columns: repeat(auto-fit, minmax(8rem, 1fr))
		column-gap: 0.7rem
		row-gap: 0.7rem
		place-items: center
	
	.card
		background: var(--darker)
</style>
