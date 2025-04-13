<script lang="ts">
	import Head from "$components/Head.svelte"
	import UserCard from "$components/UserCard.svelte"

	let { data } = $props();
</script>

<Head name={data.siteName} title="Members of {data.name}" />

<h1 class="text-center">Members of {data.name} ({data.memberCount})</h1>

<div class="ctnr pt-12 grid">
	{#each data.members as user, num}
		<UserCard {user} {num} total={data.members.length} />
	{/each}
</div>

<style>
	.ctnr {
		max-width: 100%;
		font-size: 0.9rem;

		grid-template-columns: repeat(auto-fit, minmax(16rem, 1fr));
		column-gap: 1rem;
		row-gap: 1rem;
		place-items: center;
	}
</style>
