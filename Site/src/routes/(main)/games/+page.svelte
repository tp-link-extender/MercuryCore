<script lang="ts">
	import { enhance } from "$app/forms"
	import { page } from "$app/stores"
	import Head from "$components/Head.svelte"
	import fade from "$lib/fade"
	import PlacePage from "../place/[id=integer]/[name]/+page.svelte"
	import PlaceCard from "./PlaceCard.svelte"

	export let data

	let query = ""
	let searchedData: typeof data.places = []

	// Run function whenever query changes
	async function search() {
		const response = await fetch(`/games/search?q=${query}`)
		searchedData = (await response.json()) as typeof data.places
	}
	$: query && search()

	$: places = query ? searchedData : data.places || []

	export const snapshot = {
		capture: () => query,
		restore: v => {
			query = v
		}
	}
</script>

<Head title="Discover" />

<div class="ctnr">
	<div class="flex pb-12 gap-4 <sm:flex-wrap">
		<div class="flex w-full sm:w-1/2">
			<h1 class="pr-6">Games</h1>
			<a href="/games/create" class="btn btn-primary">
				<fa fa-plus class="pr-2" />
				Create
			</a>
		</div>
		<div class="w-full sm:w-1/2">
			<form
				use:enhance
				method="POST"
				action="/search?c=places"
				class="flex gap-4">
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
			</form>
		</div>
	</div>
	{#if places.length > 0}
		<div class="flex flex-wrap gap-4 justify-center">
			{#each places as place, num (place.id)}
				<PlaceCard {place} {num} total={data.places.length} />
			{/each}
			{#if query && searchedData.length === 0}
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

<style>
	input {
		background-color: var(--accent);
		border-color: var(--accent2);
	}
	.modal-box {
		max-height: initial !important;
	}
</style>
