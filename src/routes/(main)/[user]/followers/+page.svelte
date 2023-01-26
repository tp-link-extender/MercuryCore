<script lang="ts">
		const statusColours: any = {
		Online: "bg-info",
		Joined: "bg-success",
		Developing: "bg-warning",
	}

	export let data: any
</script>

<svelte:head>
	<title>{data.displayname}'s followers - Mercury</title>
</svelte:head>

<h1 class="light-text text-center">{data.displayname}'s followers ({data.number})</h1>

<div class="container mt-5 d-grid">
	{#each Array(50) as _}
		{#each data.users as user}
			<a class="card light-text w-100 d-flex flex-row" href="/{user.username}">
				<div class="p-4">
					<div class="image-background rounded-circle">
						<img src={user.image} alt={user.displayname || user.username} class="h-100 rounded-circle img-fluid rounded-top-0" />
					</div>
					{#if user.status}
						<span class="position-absolute bottom-0 end-0 badge rounded-circle {statusColours[user.status]}">
							<span class="visually-hidden">{user.status}</span>
						</span>
					{/if}
				</div>
				<p class="h4 p-4">
					{user.displayname || user.username}
				</p>
			</a>
		{/each}
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
		text-decoration: none
		background: var(--darker)
		p
			width: fit-content
		
		.badge
			padding: 0.75rem
		.image-background
			background: var(--accent)
			width: fit-content
			img
				max-height: 6rem
</style>
