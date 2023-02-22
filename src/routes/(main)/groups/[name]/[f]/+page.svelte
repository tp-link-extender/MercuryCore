<script lang="ts">
	// The friends, followers, and following pages for a user.

	import type { PageData } from "./$types"
	import UserCard from "$lib/components/UserCard.svelte"

	export let data: PageData

	const titles: any = {
		followers: `${data.name}'s followers`,
		members: `Members of ${data.name}`,
	}
</script>

<svelte:head>
	<title>{titles[data.type]} - Mercury</title>
</svelte:head>

<h1 class="light-text text-center">{titles[data.type]} ({data.number})</h1>

<div class="container mt-5 d-grid">
	{#each data.users as user, num}
		<UserCard {user} {num} total={data.users.length} />
	{/each}
</div>

<style lang="sass">
	.container
		max-width: 100%
		font-size: 0.9rem

		grid-template-columns: repeat(auto-fit, minmax(16rem, 1fr))
		column-gap: 1rem
		row-gap: 1rem
		place-items: center
</style>
