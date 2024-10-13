<script lang="ts">
	import { page } from "$app/stores"
	import Head from "$components/Head.svelte"
	import Pagination from "$components/Pagination.svelte"
	import PlaceCard from "./PlaceCard.svelte"

	export let data
</script>

<Head name={data.siteName} title="Discover" />

<div class="ctnr">
	<div class="flex pb-12 gap-4 <sm:flex-wrap">
		<div class="flex w-full sm:w-1/2">
			<h1 class="pr-6">Games</h1>
			<a href="/games/create" class="btn btn-primary">
				<fa fa-plus class="pr-2"></fa>
				Create
			</a>
		</div>
	</div>
	{#if data.places.length > 0}
		<div class="flex flex-wrap gap-4 justify-center">
			{#each data.places as place, num (place.id)}
				<PlaceCard {place} {num} total={data.places.length} />
			{/each}
		</div>
		{#key $page.url}
			<Pagination totalPages={data.pages} />
		{/key}
	{:else}
		<h2 class="text-center">No games yet. Be the first to create one!</h2>
	{/if}
</div>
