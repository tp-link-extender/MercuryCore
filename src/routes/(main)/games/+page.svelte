<script lang="ts">
	import { page } from "$app/stores"
	import PlaceCard from "./PlaceCard.svelte"
	import PlacePage from "../place/[id]/[name]/+page.svelte"

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
				body: formdata
			})
			const result = deserialize(await response.text()) as {
				data: {
					places: typeof data.places
				}
			}

			searchedData = result.data.places
		})()

	$: places = query ? searchedData : data.places || []

	export const snapshot = {
		capture: () => query,
		restore: v => (query = v)
	}
</script>

<Head title="Discover" />

<div class="ctnr">
	<div class="flex pb-12">
		<h1 class="w-1/3">
			<span class="pr-6">Games</span>
			<a href="/games/create" class="btn btn-primary">
				<fa fa-plus />
				Create
			</a>
		</h1>
		<div class="w-2/3">
			<form
				use:enhance
				method="POST"
				action="/search?c=places"
				class="flex gap-4">
				<div class="w-5/12">
					<div class="input-group">
						<input
							bind:value={query}
							type="text"
							name="query"
							placeholder="Search for a game"
							aria-label="Search for a game"
							aria-describedby="button-addon2" />
						<button
							class="btn btn-secondary"
							aria-label="Search"
							id="button-addon2">
							<fa fa-magnifying-glass />
						</button>
					</div>
				</div>
				<div class="pl-4 w-7/24 flex">
					<label for="genre" class="light-text py-1 pr-4">
						Genre
					</label>
					<select
						class="form-select light-text"
						id="genre"
						placeholder="Genre"
						aria-label="genre">
						<option value="Obby">Obby</option>
						<option value="Horror">Horror</option>
						<option value="Comedy">Comedy</option>
					</select>
				</div>
				<div class="pl-4 w-7/24">
					<div class="flex items-center light-text py-1">
						<input
							class="form-check-input"
							type="checkbox"
							value=""
							id="flexCheckDefault" />
						<label class="pl-2" for="flexCheckDefault">
							Gears Allowed
						</label>
					</div>
				</div>
			</form>
		</div>
	</div>
	{#if places.length > 0}
		<div class="flex flex-wrap gap-4 justify-center">
			{#each places as place, num (place.id)}
				<PlaceCard {place} {num} total={data.places.length} />
			{/each}
			{#if query && searchedData.length == 0}
				<h2 class="text-lg pt-12">
					No games found with search term {query}
				</h2>
			{/if}
		</div>
	{:else}
		<h2 class="text-center">No games yet. Be the first to create one!</h2>
	{/if}
</div>

{#if $page.state.openPlace}
	<div
		class="modal-static fixed w-full h-full z-10 overflow-y-auto p-20 px-10">
		<div
			transition:fade={{ duration: 200 }}
			role="button"
			tabindex="0"
			on:click={() => history.back()}
			on:keypress={() => history.back()}
			class="modal-backdrop" />
		<div
			transition:fade={{ duration: 100 }}
			class="modal-box bg-background py-10">
			<PlacePage data={$page.state.openPlace} />
		</div>
	</div>
{/if}

<style lang="stylus">
	input
	select
		background-color var(--accent)
		border-color var(--accent2)

	.modal-box
		max-height initial !important
</style>
