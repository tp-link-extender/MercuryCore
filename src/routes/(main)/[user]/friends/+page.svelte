<script lang="ts">
		const statusColours: any = {
		Online: "bg-info",
		Joined: "bg-success",
		Developing: "bg-warning",
	}

	export let data: any
</script>

<svelte:head>
	<title>{data.displayname}'s friends - Mercury</title>
</svelte:head>

<h1 class="light-text text-center">{data.displayname}'s friends ({data.number})</h1>

<div class="container">
	<div class="row">
		<div class="col">
			<div class="container d-grid">
				{#each Array(50) as _}
					{#each data.users as user}
						<a class="user px-2 mb-2 text-center light-text" href="/{user.username}">
							<div class="position-relative mb-2">
								<div class="image-background rounded-circle">
									<img src={user.image} alt={user.displayname || user.username} class="h-100 rounded-circle img-fluid rounded-top-0" />
								</div>
								{#if user.status}
									<span class="position-absolute bottom-0 end-0 badge rounded-circle {statusColours[user.status]}">
										<span class="visually-hidden">{user.status}</span>
									</span>
								{/if}
							</div>
							{user.displayname || user.username}
						</a>
					{/each}
				{/each}
			</div>
		</div>
	</div>
</div>

<style lang="sass">
	.container
		max-width: 100%
		font-size: 0.9rem

		grid-template-columns: repeat(auto-fit, minmax(10rem, 1fr))
		column-gap: 1rem
		row-gap: 1rem
		place-items: center

	.user
		text-decoration: none
		.badge
			padding: 0.75rem
		.image-background
			background: var(--accent)
			aspect-ratio: 1
			margin: auto
</style>
