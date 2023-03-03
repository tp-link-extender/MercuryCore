<script lang="ts">
	import type { PageData } from "./$types"
	import Place from "$lib/components/Place.svelte"
	import Item from "$lib/components/Item.svelte"
	import Group from "$lib/components/Group.svelte"

	const statusColours: any = {
		Online: "bg-info",
		Joined: "bg-success",
		Developing: "bg-warning",
	}

	export let data: PageData
</script>

<svelte:head>
	<title>Search for {data.query} - Mercury</title>
</svelte:head>

{#if data.category}
	<h1 class="text-center light-text">
		Search for "{data.query}" in {data.category}
	</h1>
{:else}
	<h1 class="text-center light-text h2">
		Choose a category to search for "{data.query}"
	</h1>
{/if}

<div class="container-fluid mt-5">
	{#if data.category == "users" && data.users}
		<div class="grid d-grid">
			{#each data.users as user}
				<a class="px-2 mb-2 text-center light-text text-decoration-none" href="/user/{user.number}">
					<div class="position-relative mb-2">
						<div class="image-background rounded-circle">
							<img src={user.image} alt={user.username} class="h-100 rounded-circle img-fluid rounded-top-0" />
						</div>
						{#if user.status}
							<span class="position-absolute bottom-0 end-0 badge rounded-circle {statusColours[user.status]}">
								<span class="visually-hidden">{user.status}</span>
							</span>
						{/if}
					</div>
					{user.username}
				</a>
			{/each}
		</div>
	{:else if data.category == "places" && data.places}
		<div class="grid d-grid">
			{#each data.places as place, num}
				<div class="px-2 mb-2">
					<div class="place">
						<Place {place} {num} total={data.places.length} />
					</div>
				</div>
			{/each}
		</div>
	{:else if data.category == "items" && data.items}
		<div class="grid d-grid">
			{#each data.items as item, num}
				<div class="px-2 mb-2">
					<div class="place">
						<Item {item} {num} total={data.items.length} />
					</div>
				</div>
			{/each}
		</div>
	{:else if data.category == "groups" && data.groups}
		<div class="grid d-grid">
			{#each data.groups as group, num}
				<div class="px-2 mb-2">
					<div class="place">
						<Group {group} {num} total={data.groups.length} />
					</div>
				</div>
			{/each}
		</div>
	{:else}
		<div id="buttons" class="d-flex justify-content-center gap-3">
			<a class="btn btn-primary" href="/search?q={data.query}&c=users">Users</a>
			<a class="btn btn-primary" href="/search?q={data.query}&c=places">Places</a>
			<a class="btn btn-primary" href="/search?q={data.query}&c=items">Items</a>
		</div>
	{/if}
</div>

<style lang="sass">
	.grid
		grid-template-columns: repeat(auto-fill, minmax(8rem, 1fr))
		grid-gap: 0 1rem

		.badge
			padding: 0.75rem
		.place
			width: 8rem
			margin: auto
		.image-background
			background: var(--accent)
			width: 7rem
			margin: auto
</style>
