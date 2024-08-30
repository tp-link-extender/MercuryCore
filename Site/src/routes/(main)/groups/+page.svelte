<script lang="ts">
	import { enhance } from "$app/forms"
	import { page } from "$app/stores"
	import Group from "$components/Group.svelte"
	import Head from "$components/Head.svelte"
	import Pagination from "$components/Pagination.svelte"

	export let data
</script>

<Head name={data.siteName} title="Groups" />

<div class="ctnr">
	<div class="flex pb-6">
		<h1 class="w-1/2">
			<span class="pr-6">Groups</span>
			<a href="/groups/create" class="btn btn-primary">Create</a>
		</h1>
	</div>

	{#if data.groups.length > 0}
		<div class="grid text-0.9rem">
			{#each data.groups as group, num (group.name)}
				<Group {group} {num} total={data.groups.length} />
			{/each}
		</div>
		{#key $page.url}
			<Pagination totalPages={data.pages} />
		{/key}
	{:else}
		<h2 class="text-center">No groups yet. Be the first to create one!</h2>
	{/if}
</div>

<style>
	.grid {
		grid-template-columns: repeat(auto-fit, minmax(11rem, 1fr));
		column-gap: 0.7rem;
		row-gap: 0.7rem;
		place-items: center;
	}
</style>
