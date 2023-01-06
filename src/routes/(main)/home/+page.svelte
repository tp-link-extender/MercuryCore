<script lang="ts">
	import { getUser } from "@lucia-auth/sveltekit/client"
	export let data: any
	const user = getUser()

	// explicitly any to prevent warnings
	const statusColours: any = {
		Online: "bg-info",
		Joined: "bg-success",
		Developing: "bg-warning",
	}
</script>

<svelte:head>
	<title>Home - Mercury</title>
</svelte:head>

<div class="container">
	<div class="top d-flex px-2">
		<div id="pfp">
			<img src={$user?.image} alt="You" />
		</div>
		<h1 class="text-center light-text">Hi, {$user?.username}!</h1>
	</div>
	<div class="mt-5">
		{#if data.friends.length > 0}
			<h4 class="light-text">Friends</h4>
			<div id="friends" class="d-flex">
				{#each data.friends as friend}
					<a class="friend px-2 mb-2 text-center light-text" href="/{friend.username}">
						<div class="position-relative mb-2">
							<div class="image-background">
								<img src={friend.image} alt={friend.displayname || friend.username} class="h-100" />
							</div>
							{#if friend.status}
								<span class="position-absolute bottom-0 end-0 badge rounded-circle {statusColours[friend.status]}">
									<span class="visually-hidden">{friend.status}</span>
								</span>
							{/if}
						</div>
						{friend.displayname || friend.username}
					</a>
				{/each}
			</div>
		{/if}
	</div>
	<div class="mt-5">
		<h4 class="light-text">Recently joined</h4>
		<div class="row p-0">
			{#each data.places as place}
				<a class="place col col-4 col-sm-3 col-md-2 text-center light-text px-2" href="/{place.ownerUsername}/{place.name}">
					<img src={place.image} class="mb-2 w-100" alt={place.name} />
					{place.name}
				</a>
			{/each}
		</div>
	</div>
	<br /><br />
</div>

<style lang="sass">
	.container
		max-width: 60rem
		font-size: 0.9rem

	.top
		width: fit-content
		#pfp
			background: var(--accent2)
			border-radius: 100%
		img
			height: 6rem
			border-radius: 0 0 50% 50%
		h1
			margin: auto 2rem

	.row
		margin: 0

	#friends
		overflow-x: auto
		.friend 
			text-decoration: none
			.badge
				padding: 0.75rem
			.image-background
				background: var(--accent2)
				width: 7rem
				height: 7rem
				border-radius: 50%
				margin: auto
				img
					border-radius: 0 0 50% 50%
					
	.place
		border-radius: 0.5rem
		margin-bottom: 1rem
		text-decoration: none
		img
			background: black
			

	.place img
		border-radius: 0.5rem
</style>
