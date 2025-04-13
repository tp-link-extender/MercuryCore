<script lang="ts">
	import Asset from "$components/Asset.svelte"
	import Group from "$components/Group.svelte"
	import Head from "$components/Head.svelte"
	import Place from "$components/Place.svelte"
	import User from "$components/User.svelte"
	import fade from "$lib/fade"

	const { data } = $props()
</script>

<Head name={data.siteName} title="Search for {data.query}" />

<h1 class="text-center">
	Search for "{data.query}" in {data.category}
</h1>

<div class="pt-12 px-4">
	{#if data.category === "users" && data.users}
		<div class="grid">
			{#each data.users as user, num}
				<div in:fade={{ num, total: data.users.length }}>
					<User {user} size="7rem" bg="accent" bottom />
				</div>
			{/each}
		</div>
	{:else if data.category === "places" && data.places}
		<div class="grid">
			{#each data.places as place, num}
				<div class="px-2 pb-2">
					<Place {place} {num} total={data.places.length} />
				</div>
			{/each}
		</div>
	{:else if data.category === "assets" && data.assets}
		<div class="grid">
			{#each data.assets as asset, num}
				<div class="pb-4">
					<Asset
						{asset}
						{num}
						total={data.assets.length}
						symbol={data.currencySymbol} />
				</div>
			{/each}
		</div>
	{:else if data.category === "groups" && data.groups}
		<div class="grid">
			{#each data.groups as group, num}
				<div class="px-2 pb-2">
					<Group {group} {num} total={data.groups.length} />
				</div>
			{/each}
		</div>
	{/if}
</div>

<style>
	.grid {
		grid-template-columns: repeat(auto-fill, minmax(8rem, 1fr));
		grid-gap: 0 1rem;
	}
</style>
