<script lang="ts">
	import Asset from "$components/Asset.svelte"
	import Group from "$components/Group.svelte"
	import Head from "$components/Head.svelte"
	import Place from "$components/Place.svelte"
	import User from "$components/User.svelte"
	import fade from "$lib/fade"

	export let data
</script>

<Head title="Search for {data.query}" />

{#if data.category}
	<h1 class="text-center">
		Search for "{data.query}" in {data.category}
	</h1>
{:else}
	<h1 class="text-center text-2xl">
		Choose a category to search for "{data.query}"
	</h1>
{/if}

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
					<Asset {asset} {num} total={data.assets.length} />
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
	{:else}
		<div id="buttons" class="flex justify-center gap-4">
			<a class="btn btn-primary" href="/search?q={data.query}&c=users">
				Users
			</a>
			<a class="btn btn-primary" href="/search?q={data.query}&c=places">
				Places
			</a>
			<a class="btn btn-primary" href="/search?q={data.query}&c=assets">
				Catalog
			</a>
		</div>
	{/if}
</div>

<style>
	.grid {
		grid-template-columns: repeat(auto-fill, minmax(8rem, 1fr));
		grid-gap: 0 1rem;

		& div a {
			width: 8rem;
			margin: auto;
		}
	}
</style>
