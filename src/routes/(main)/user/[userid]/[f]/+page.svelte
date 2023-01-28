<script lang="ts">
	import type { PageData } from "./$types"

	const statusColours: any = {
		Online: "bg-info",
		Joined: "bg-success",
		Developing: "bg-warning",
	}

	export let data: PageData

	const titles: any = {
		friends: `${data.displayname}'s friends`,
		followers: `${data.displayname}'s followers`,
		following: `Followed by ${data.displayname}`,
	}
</script>

<svelte:head>
	<title>{titles[data.type]} - Mercury</title>
</svelte:head>

<h1 class="light-text text-center">{titles[data.type]} ({data.number})</h1>

<div class="container mt-5 d-grid">
	{#each data.users as user}
		<a class="card light-text h-100 w-100 d-flex flex-row" href="/user/{user.id}">
			<div class="p-4">
				<div class="image-background rounded-circle">
					<img src={user.image} alt={user.displayname} class="h-100 rounded-circle img-fluid rounded-top-0" />
				</div>
				{#if user.status}
					<span class="position-absolute bottom-0 end-0 badge rounded-circle {statusColours[user.status]}">
						<span class="visually-hidden">{user.status}</span>
					</span>
				{/if}
			</div>
			<p class="h4 p-4">
				aaaaaaaaaaaaaa{user.displayname}
			</p>
		</a>
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

	.card
		max-width: 25rem
		text-decoration: none
		background: var(--darker)
		p
			width: fit-content
			word-break: break-all
		
		.badge
			padding: 0.75rem
		.image-background
			background: var(--accent)
			min-width: 6rem
			img
				width: 6rem
				max-height: 6rem
</style>
