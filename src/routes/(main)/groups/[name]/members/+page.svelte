<script lang="ts">
	export let data
</script>

<svelte:head>
	<title>Members of {data.name} - Mercury</title>
</svelte:head>

<h1 class="light-text text-center">Members of {data.name} ({data.number})</h1>

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
