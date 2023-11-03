<script lang="ts">
	// The friends, followers, and following pages for a user.

	export let data

	const titles = {
		friends: `${data.username}'s friends`,
		followers: `${data.username}'s followers`,
		following: `Followed by ${data.username}`,
	}
</script>

<Head title={titles[data.type]} />

<h1 class="text-center">{titles[data.type]} ({data.number})</h1>

<div class="container mt-12 d-grid">
	{#each data.users as user, num}
		<UserCard {user} {num} total={data.users.length} />
	{/each}
</div>

<style lang="stylus">
	.container
		max-width 100%
		font-size 0.9rem

		grid-template-columns repeat(auto-fit, minmax(20rem, 1fr))
		column-gap 1rem
		row-gap 1rem
		place-items center
</style>
