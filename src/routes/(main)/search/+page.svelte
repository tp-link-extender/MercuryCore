<script lang="ts">
	// const statusColours: { [k: string]: string } = {
	// 	Online: "bg-info",
	// 	Joined: "bg-success",
	// 	Developing: "bg-warning",
	// }

	export let data
</script>

<Head title="Search for {data.query}" />

{#if data.category}
	<h1 class="text-center light-text">
		Search for "{data.query}" in {data.category}
	</h1>
{:else}
	<h1 class="text-center light-text fs-2">
		Choose a category to search for "{data.query}"
	</h1>
{/if}

<div class="container-fluid mt-12">
	{#if data.category == "users" && data.users}
		<div class="grid d-grid">
			{#each data.users as user, num}
				<a
					in:fade={{ num, total: data.users.length }}
					class="px-2 mb-2 text-center light-text text-decoration-none"
					href="/user/{user.number}">
					<div class="position-relative mb-2">
						<div class="image-background bg-a rounded-circle">
							<img
								src="/api/avatar/{user.username}"
								alt={user.username}
								class="h-100 rounded-circle rounded-top-0" />
						</div>
						<!-- {#if user.status}
							<span
								class="position-absolute bottom-0 end-0 badge rounded-circle {statusColours[
									user.status
								]}">
							</span>
						{/if} -->
					</div>
					{user.username}
				</a>
			{/each}
		</div>
	{:else if data.category == "places" && data.places}
		<div class="grid d-grid">
			{#each data.places as place, num}
				<div class="px-2 mb-2">
					<Place {place} {num} total={data.places.length} />
				</div>
			{/each}
		</div>
	{:else if data.category == "assets" && data.assets}
		<div class="grid d-grid">
			{#each data.assets as asset, num}
				<div class="px-2 mb-2">
					<Asset {asset} {num} total={data.assets.length} />
				</div>
			{/each}
		</div>
	{:else if data.category == "groups" && data.groups}
		<div class="grid d-grid">
			{#each data.groups as group, num}
				<div class="px-2 mb-2">
					<Group {group} {num} total={data.groups.length} />
				</div>
			{/each}
		</div>
	{:else}
		<div id="buttons" class="d-flex justify-content-center gap-4">
			<a class="btn btn-primary" href="/search?q={data.query}&c=users">
				Users
			</a>
			<a class="btn btn-primary" href="/search?q={data.query}&c=places">
				Places
			</a>
			<a class="btn btn-primary" href="/search?q={data.query}&c=assets">
				Assets
			</a>
		</div>
	{/if}
</div>

<style lang="stylus">
	.grid
		grid-template-columns repeat(auto-fill, minmax(8rem, 1fr))
		grid-gap 0 1rem

		div a
			width 8rem
			margin auto

	.image-background
	img
		width 7rem
		margin auto
</style>
