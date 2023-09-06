<script lang="ts">
	export let data
</script>

<Head title="Members of {data.name}" />

<h1 class="light-text text-center">Members of {data.name} ({data.number})</h1>

<div class="container mt-12 d-grid">
	{#each data.users as user, num}
		<UserCard {user} {num} total={data.users.length} />
	{/each}
</div>

<style lang="stylus">
	.container
		max-width 100%
		font-size 0.9rem

		grid-template-columns repeat(auto-fit, minmax(16rem, 1fr))
		column-gap 1rem
		row-gap 1rem
		place-items center
</style>
