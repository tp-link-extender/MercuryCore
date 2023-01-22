<script lang="ts">
	import { enhance } from "$app/forms"
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
		<div class="pfp rounded-circle">
			<img src={$user?.image} alt="You" class="rounded-circle img-fluid rounded-top-0" />
		</div>
		<h1 class="text-center light-text">
			{greets[Math.floor(Math.random() * greets.length)]}
		</h1>
	</div>
	<div class="row">
		<div class="col col-12 col-xl-5 col-md-6 col-sm-12">
			<div id="feed" class="card mt-5 overflow-auto">
				<div class="card-body light-text col">
					<p>Post your status - your friends and followers can view how you're doing!</p>
					<form method="POST" use:enhance>
						<div class="input-group mb-3">
							<input type="text" class="form-control light-text" placeholder="Post status" name="status" aria-label="Post Status" required />
							<button class="btn btn-success" type="submit" id="button-addon2">Send</button>
						</div>
					</form>
					{#if data.feed.length > 0}
						{#each data.feed.sort((a, b) => b.date - a.date) as status}
							<div class="card mb-2">
								<div class="card-body">
									<a id="user" class="d-flex mb-2 text-decoration-none" href="/{status.username}">
										<span class="pfp rounded-circle">
											<img src={status.image} alt={status.displayname} class="rounded-circle img-fluid rounded-top-0" />
										</span>
										<span class="fw-bold ms-3 light-text">{status.displayname}</span>
									</a>
									<span class="float-end fw-italic">{status.date.toLocaleString()}</span>
									<p class="text-start">
										{status.text}
									</p>
								</div>
							</div>
						{/each}
					{/if}
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
					{#each data.places || [] as place}
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
		.pfp
			background: var(--accent)
		img
			height: 6rem
		h1
			margin: auto 2rem

	input
		background: var(--accent)
		border-color: var(--accent2)
	.card
		background: var(--accent)

	#feed
		background: var(--darker)
		max-height: 50vh
		#user
			align-items: center
			.pfp
				background: var(--accent2)
				img
					width: 2rem

	#friends
		overflow-x: auto
		.friend 
			text-decoration: none
			.badge
				padding: 0.75rem
			.image-background
				background: var(--accent)
				width: 7rem
				height: 7rem
				margin: auto
</style>
