<script lang="ts">
	import PlaceCard from "./PlaceCard.svelte"

	export let data

	let query = "",
		searchedData: typeof data.places = []

	// Run function whenever query changes
	$: query &&
		(async () => {
			const formdata = new FormData()
			formdata.append("q", query)

			const response = await fetch("/games", {
				method: "POST",
				body: formdata,
			})
			const result: any = deserialize(await response.text())

			searchedData = result.data.places
		})()

	export const snapshot = {
		capture: () => query,
		restore: v => (query = v),
	}
</script>

<Head title="Discover" />

<div class="container">
	<div class="row pb-12">
		<h1 class="col light-text">
			Games
			<span class="ps-6">
				<a href="/games/create" class="btn btn-primary">
					<i class="fas fa-plus" />
					Create
				</a>
			</span>
		</h1>
		<div class="col-8">
			<form
				use:enhance
				method="POST"
				action="/search?c=places"
				class="row">
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
						<button
							class="btn btn-success"
							aria-label="Search"
							id="button-addon2">
							<i class="fa fa-magnifying-glass" />
						</button>
					</div>
				</div>
				<div class="col-7 row">
					<div class="ps-4 col">
						<div class="row">
							<label
								for="genre"
								class="light-text col py-1">
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
					<div class="ms-4 col">
						<div class="form-check light-text py-1">
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
			{#each query ? searchedData : data.places || [] as place, num (place.id)}
				<PlaceCard {place} {num} total={data.places.length} />
			{/each}
			{#if query && searchedData.length == 0}
				<h2 class="fs-5 light-text pt-12">
					No games found with search term {query}
				</h2>
			{/if}
		</div>
	</div>
</div>

<style lang="stylus">
	input
	select
		background-color var(--accent)
		border-color var(--accent2)

	.d-grid
		font-size 0.9rem

		grid-template-columns repeat(auto-fit, minmax(19rem, 1fr))
		column-gap 0.7rem
		row-gap 0.7rem
		place-items center
</style>
