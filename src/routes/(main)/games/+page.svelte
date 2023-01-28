<script lang="ts">
	import PlaceCard from "$lib/components/PlaceCard.svelte"
	export let data: any
</script>

<svelte:head>
	<title>Discover - Mercury</title>
</svelte:head>

<h1 class="light-text text-center">Games</h1>

<div class="container row">
	<div class="col-lg-4 col-xl-3 mb-4 mb-auto pe-0 pb-3">
		<div class="card rounded-none">
			<div class="card-header light-text px-3 py-2"><i class="fa-solid fa-magnifying-glass" /> Filter</div>
			<div class="card-body">
				<form>
					<div class="input-group mb-3">
						<input type="text" class="form-control" placeholder="Search" aria-label="Search" aria-describedby="button-addon2" />
						<button class="btn btn-success" type="button" id="button-addon2">Search</button>
					</div>
					<p>
						<a class="text-decoration-none" data-bs-toggle="collapse" href="#collapse" role="button" aria-expanded="false" aria-controls="collapse">
							<b>Advanced</b> <i class="fa-solid fa-circle-chevron-down" />
						</a>
					</p>
					<div class="collapse" id="collapse">
						<div class="mb-3">
							<label for="genre" class="form-label light-text">Genre</label>
							<select class="form-select form-select-sm light-text" id="genre" placeholder="Genre" aria-label="genre">
								<option value="Obby">Obby</option>
								<option value="Horror">Horror</option>
								<option value="Comedy">Comedy</option>
							</select>
						</div>
						<div class="mb-3">
							<div class="form-check light-text">
								<input class="form-check-input" type="checkbox" value="" id="flexCheckDefault" />
								<label class="form-check-label" for="flexCheckDefault"> Gears Allowed </label>
							</div>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
	<div class="col pe-0">
		<div class="container d-grid p-0">
			{#each Array(10) as _}
				{#each data.places || [] as place}
					<PlaceCard {place} />
				{/each}
			{/each}
		</div>
	</div>
</div>

<style lang="sass">
	input, select
		background-color: var(--accent)
		border-color: var(--accent2)

	.container
		max-width: 100%
		font-size: 0.9rem

	.d-grid
		grid-template-columns: repeat(auto-fit, minmax(16rem, 1fr))
		column-gap: 0.7rem
		row-gap: 0.7rem
		place-items: center
	
	.card
		background: var(--darker)
</style>
