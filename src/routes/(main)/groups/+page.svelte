<script lang="ts">
	import { enhance, deserialize } from "$app/forms"
	import Group from "$lib/components/Group.svelte"
	import { onMount } from "svelte"

	let query = ""
	let rendered = false
	onMount(() => (rendered = true))

	let searchedData: any[] = []

	// Run function whenever query changes
	$: (query || rendered) &&
		(async () => {
			const formdata = new FormData()
			formdata.append("query", query)

			const response = await fetch("/groups", {
				method: "POST",
				body: formdata,
			})

			const result: any = deserialize(await response.text())
			searchedData = result.data.places
		})()

	// Snapshots allow form values on a page to be restored
	// if the user navigates away and then back again.
	export const snapshot = {
		capture: () => query,
		restore: v => (query = v),
	}

	export let data
</script>

<svelte:head>
	<title>Groups - Mercury</title>
</svelte:head>

<div class="container">
	<div class="row mb-5">
		<h1 class="col-6 light-text">
			Groups
			<a href="/groups/create" class="btn btn-primary ms-4">Create</a>
		</h1>
		<div class="col-4 ms-4">
			<form use:enhance method="POST" action="/search" class="row">
				<div class="input-group">
					<input
						bind:value={query}
						type="text"
						name="query"
						class="form-control light-text valid"
						placeholder="Search for a group"
						aria-label="Search for a group"
						aria-describedby="button-addon2" />
					<input type="hidden" name="category" value="places" />
					<button
						class="btn btn-success"
						type="submit"
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
				<h2 class="h5 light-text mt-5">
					No groups found with search term {query}
				</h2>
			{/if}
		</div>
	</div>
</div>

<style lang="sass">
	input
		background-color: var(--accent)
		border-color: var(--accent2)

	.d-grid
		font-size: 0.9rem

		grid-template-columns: repeat(auto-fit, minmax(11rem, 1fr))
		column-gap: 0.7rem
		row-gap: 0.7rem
		place-items: center
</style>
