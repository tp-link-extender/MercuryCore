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
					body: formdata,
				}),
				result: any = deserialize(await response.text())

			searchedData = result.data.groups
		})()

	// Snapshots allow form values on a page to be restored
	// if the user navigates away and then back again.
	export const snapshot = {
		capture: () => query,
		restore: v => (query = v),
	}
</script>

<Head title="Groups" />

<div class="container">
	<div class="row mb-12">
		<h1 class="col-6 light-text">
			Groups
			<a href="/groups/create" class="btn btn-primary ms-6">Create</a>
		</h1>
		<div class="col-4 ms-6">
			<form
				use:enhance
				method="POST"
				action="/search?c=groups"
				class="row">
				<div class="input-group">
					<input
						bind:value={query}
						type="text"
						name="query"
						class="form-control light-text valid"
						placeholder="Search for a group"
						aria-label="Search for a group"
						aria-describedby="button-addon2" />
					<button
						class="btn btn-success"
						aria-label="Search"
						id="button-addon2">
						<i class="fa fa-magnifying-glass" />
					</button>
				</div>
			</form>
		</div>
	</div>
	<div class="row">
		<div class="container d-grid m-0">
			{#each query ? searchedData : data.groups || [] as group, num (group.name)}
				<Group {group} {num} total={data.groups.length} />
			{/each}
			{#if query && searchedData.length == 0}
				<h2 class="fs-5 light-text mt-12">
					No groups found with search term {query}
				</h2>
			{/if}
		</div>
	</div>
</div>

<style lang="stylus">
	input
		background-color var(--accent)
		border-color var(--accent2)

	.d-grid
		font-size 0.9rem

		grid-template-columns repeat(auto-fit, minmax(11rem, 1fr))
		column-gap 0.7rem
		row-gap 0.7rem
		place-items center
</style>
