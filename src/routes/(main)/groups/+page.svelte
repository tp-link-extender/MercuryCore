<script lang="ts">
	import type { PageData, Snapshot } from "./$types"
	import { enhance } from "$app/forms"
	import Group from "$lib/components/Group.svelte"

	let value = ""

	export const snapshot: Snapshot = {
		capture: () => value,
		restore: v => (value = v),
	}

	export let data: PageData
</script>

<svelte:head>
	<title>Groups - Mercury</title>
</svelte:head>

<h1 class="light-text text-center">Groups</h1>

<div class="container row">
	<div class="col-lg-4 col-xl-3 mb-4 mb-auto pe-0 pb-3">
		<div class="card rounded-none">
			<div class="card-header light-text px-3 py-2"><i class="fa fa-magnifying-glass" /> Filter</div>
			<div class="card-body">
				<form use:enhance method="POST" action="/search">
					<div class="input-group mb-3">
						<input bind:value type="text" name="query" class="form-control light-text input" placeholder="Search" aria-label="Search" aria-describedby="button-addon2" />
						<input type="hidden" name="category" value="groups" />
						<button class="btn btn-success" type="submit" id="button-addon2">Search</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	<div class="col pe-0">
		<div class="container d-grid p-0">
			{#each data.groups || [] as group}
				<Group {group} />
			{/each}
		</div>
	</div>
</div>

<style lang="sass">
	.input
		background-color: var(--accent)
		border-color: var(--accent2)

	.container
		max-width: 100%
		font-size: 0.9rem

	.d-grid
		grid-template-columns: repeat(auto-fit, minmax(16rem, 1fr))
		column-gap: 0.7rem
		row-gap: 0.7rem
		place-items: center
	
	.card
		background: var(--darker)
</style>
