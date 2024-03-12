<script lang="ts">
	export let data

	let query = "",
		searchedData: typeof data.groups = []

	// Run function whenever query changes
	$: query &&
		(async () => {
			const formdata = new FormData()
			formdata.append("q", query)

			const response = await fetch("/groups", {
				method: "POST",
				body: formdata
			})
			const result = deserialize(await response.text()) as {
				data: {
					groups: typeof data.groups
				}
			}

			searchedData = result.data.groups
		})()

	$: groups = query ? searchedData : data.groups || []

	export const snapshot = {
		capture: () => query,
		restore: v => (query = v)
	}
</script>

<Head title="Groups" />

<div class="ctnr">
	<div class="flex pb-6">
		<h1 class="w-1/2">
			<span class="pr-6">Groups</span>
			<a href="/groups/create" class="btn btn-primary">Create</a>
		</h1>
		<div class="w-1/2 pl-6">
			<form
				use:enhance
				method="POST"
				action="/search?c=groups"
				class="input-group">
				<input
					bind:value={query}
					type="text"
					name="query"
					placeholder="Search for a group"
					aria-label="Search for a group"
					aria-describedby="button-addon2" />
				<button
					class="btn btn-secondary"
					aria-label="Search"
					id="button-addon2">
					<fa fa-magnifying-glass />
				</button>
			</form>
		</div>
	</div>

	{#if data.groups.length > 0}
		<div class="grid">
			{#each groups as group, num (group.name)}
				<Group {group} {num} total={data.groups.length} />
			{/each}
			{#if query && searchedData.length == 0}
				<h2 class="text-xs pt-12">
					No groups found with search term {query}
				</h2>
			{/if}
		</div>
	{:else}
		<h2 class="text-center">No groups yet. Be the first to post one!</h2>
	{/if}
</div>

<style lang="stylus">
	input
		background-color var(--accent)
		border-color var(--accent2)

	.grid
		font-size 0.9rem

		grid-template-columns repeat(auto-fit, minmax(11rem, 1fr))
		column-gap 0.7rem
		row-gap 0.7rem
		place-items center
</style>
