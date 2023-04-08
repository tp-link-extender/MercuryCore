<script lang="ts">
	import { enhance, deserialize } from "$app/forms"
	import PlaceCard from "$lib/components/PlaceCard.svelte"
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

			const response = await fetch("/games", {
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
	<title>Discover - Mercury</title>
</svelte:head>

<div class="container">
	<div class="row mb-5">
		<h1 class="col light-text">
			Games
			<a href="/games/create" class="btn btn-primary ms-4">
				<i class="fas fa-plus" />
				Create
			</a>
		</h1>
		<div class="col-8">
			<form use:enhance method="POST" action="/search" class="row">
				<div class="col-5">
					<div class="input-group">
						<input
							bind:value={query}
							type="text"
							name="query"
							class="form-control light-text valid"
							placeholder="Search for a game"
							aria-label="Search for a game"
							aria-describedby="button-addon2" />
						<input type="hidden" name="category" value="places" />
						<button
							class="btn btn-success"
							type="submit"
							id="button-addon2">
							<i class="fa fa-magnifying-glass" />
						</button>
					</div>
				</div>
				<div class="col-7 row">
					<div class="ms-3 col">
						<div class="row">
							<label
								for="genre"
								class="form-label light-text col mt-1">
								Genre
							</label>
							<select
								class="form-select form-select-sm light-text col"
								id="genre"
								placeholder="Genre"
								aria-label="genre">
								<option value="Obby">Obby</option>
								<option value="Horror">Horror</option>
								<option value="Comedy">Comedy</option>
							</select>
						</div>
					</div>
					<div class="ms-3 col">
						<div class="form-check light-text mt-1">
							<input
								class="form-check-input"
								type="checkbox"
								value=""
								id="flexCheckDefault" />
							<label
								class="form-check-label"
								for="flexCheckDefault">
								Gears Allowed
							</label>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
	<div class="row">
		<div class="container d-grid m-0">
			{#each query ? searchedData : data.places || [] as place, num}
				<PlaceCard {place} {num} total={data.places.length} />
			{/each}
			{#if query && searchedData.length == 0}
				<h2 class="h5 light-text mt-5">
					No games found with search term {query}
				</h2>
			{/if}
		</div>
	</div>
</div>

<style lang="sass">
	input, select
		background-color: var(--accent)
		border-color: var(--accent2)

	.d-grid
		font-size: 0.9rem

		grid-template-columns: repeat(auto-fit, minmax(16rem, 1fr))
		column-gap: 0.7rem
		row-gap: 0.7rem
		place-items: center
</style>
