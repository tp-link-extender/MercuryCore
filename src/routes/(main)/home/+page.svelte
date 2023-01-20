<script lang="ts">
	import { getUser } from "@lucia-auth/sveltekit/client"
	import Place from "$lib/components/Place.svelte"
	const user = getUser()

	// explicitly any to prevent warnings
	const statusColours: any = {
		Online: "bg-info",
		Joined: "bg-success",
		Developing: "bg-warning",
	}

	const greets = [`Hi, ${$user?.displayname}!`, `Hello, ${$user?.displayname}!`]

	export let data: any
</script>

<svelte:head>
	<title>Home - Mercury</title>
</svelte:head>

<div class="container">
	<div class="top d-flex px-2">
		<div id="pfp" class="rounded-circle">
			<img src={$user?.image} alt="You" class="rounded-circle img-fluid rounded-top-0" />
		</div>
		<h1 class="text-center light-text">
			{greets[Math.floor(Math.random() * greets.length)]}
		</h1>
	</div>
	<div class="row">
		<div class="col col-12 col-xl-5 col-md-6 col-sm-12">
			<div class="card mt-5 bg-dark">
				<div class="card-body bg-dark">
					<div class="col">
						<p class="text-light">Post your status - your friends and followers can view how you're doing!</p>
						<div class="input-group mb-3">
							<input type="text" class="form-control" placeholder="Post status" aria-label="Post Status" />
							<button class="btn btn-success" type="button" id="button-addon2">Send</button>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="col col-9 col-xl-7 col-md-6 col-sm-12">
			<div class="mt-5">
				{#if data.friends.length > 0}
					<h2 class="h4 light-text">Friends</h2>
					<div id="friends" class="d-flex">
						{#each data.friends as friend}
							<a class="friend px-2 mb-2 text-center light-text" href="/{friend.username}">
								<div class="position-relative mb-2">
									<div class="image-background rounded-circle">
										<img src={friend.image} alt={friend.displayname || friend.username} class="h-100 rounded-circle img-fluid rounded-top-0" />
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
				<h2 class="h4 light-text">Resume playing</h2>
				<div class="row m-0 p-0 rounded-0">
					{#each data.places as place}
						<div class="col col-5 col-sm-3 col-md-3 col-xl-3 text-center">
							<Place {place} />
						</div>
					{/each}
				</div>
			</div>
		</div>
	</div>
	<br /><br />
</div>

<style lang="sass">
	.container
		font-size: 0.9rem

	.top
		width: fit-content
		#pfp
			background: var(--accent2)
		img
			height: 6rem
		h1
			margin: auto 2rem

	input
		background: var(--accent)
		border-color: var(--accent3)

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
				margin: auto
</style>
