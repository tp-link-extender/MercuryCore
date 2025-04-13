<script lang="ts">
	// The friends, followers, and following pages for a user.

	import Head from "$components/Head.svelte"
	import UserCard from "$components/UserCard.svelte"

	let { data } = $props();

	const titles = {
		friends: () => `${data.username}'s friends`,
		followers: () => `${data.username}'s followers`,
		following: () => `Followed by ${data.username}`
	}
	let title = titles[data.f]()
</script>

<Head name={data.siteName} {title} />

<div class="text-center">
	<h1>{title} ({data.count})</h1>
	<a href="/user/{data.username}" class="no-underline accent-text">
		<fa fa-caret-left></fa>
		Back to {data.username}'s profile
	</a>
</div>

<div class="ctnr pt-12 grid">
	{#each data.users as user, num}
		<UserCard {user} {num} total={data.users.length} />
	{/each}
</div>

<style>
	.ctnr {
		max-width: 100%;
		font-size: 0.9rem;

		grid-template-columns: repeat(auto-fit, minmax(20rem, 1fr));
		column-gap: 1rem;
		row-gap: 1rem;
		place-items: center;
	}
</style>
