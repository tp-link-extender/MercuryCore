<script lang="ts">
	import { enhance } from "$app/forms"
	import { getUser } from "@lucia-auth/sveltekit/client"
	import Place from "$lib/components/Place.svelte"

	const user = getUser()

	export let data: any
</script>

<svelte:head>
	<title>{data.displayname} - Mercury</title>
</svelte:head>

<div id="all" class="container">
	<div class="d-flex px-4">
		<div id="image-background" class="me-4 rounded-circle">
			<img src={data.img} alt={data.displayname} class="rounded-circle rounded-top-0" />
		</div>
		<div class="container">
			<h1 class="light-text d-inline">{data.displayname}</h1>
			<h2 class="h5 d-inline light-text m-2 ps-3 opacity-50">@{data.username}</h2>
			{#if data.bio}
				<em class="light-text d-block mt-4">"{data.bio}"</em>
			{:else}
				<br />
				<br />
			{/if}
			<br />
			<div class="d-flex">
				<a href="/user/{data.id}/friends" class="light-text text-center text-decoration-none">
					Friends
					<h3 class="light-text">
						{data.friendCount}
					</h3>
				</a>
				<a href="/user/{data.id}/followers" class="light-text text-center text-decoration-none ms-4">
					Followers
					<h3 class="light-text">
						{data.followerCount}
					</h3>
				</a>
				<a href="/user/{data.id}/following" class="light-text text-center text-decoration-none ms-4">
					Following
					<h3 class="light-text">
						{data.followingCount}
					</h3>
				</a>
				{#if $user && data.username != $user?.username}
					<form class="align-self-center ms-auto me-2" method="POST" use:enhance>
						<button
							name="action"
							value={data.friends ? "unfriend" : data.outgoingRequest ? "cancel" : data.incomingRequest ? "accept" : "request"}
							class="btn {data.friends || data.outgoingRequest ? 'btn-danger' : data.incomingRequest ? 'btn-info' : 'btn-success'}"
						>
							{#if data.friends}
								Unfriend
							{:else if data.incomingRequest}
								Accept request
							{:else if data.outgoingRequest}
								Cancel request
							{:else}
								Send friend request
							{/if}
						</button>
						{#if data.incomingRequest}
							<button name="action" value="decline" class="btn btn-danger ms-2"> Decline request </button>
						{/if}
					</form>
					<form class="align-self-center" method="POST" use:enhance>
						<button name="action" value={data.following ? "unfollow" : "follow"} class="btn {data.following ? 'btn-danger' : 'btn-primary'}">
							{#if data.following}
								Unfollow
							{:else}
								Follow
							{/if}
						</button>
					</form>
				{/if}
			</div>
		</div>
	</div>
	{#if data.places.length > 0}
		<div class="mt-5">
			<h2 class="h4 light-text">Creations</h2>
			<div class="row m-0 p-0">
				{#each data.places as place}
					<div class="col col-4 col-sm-3 col-md-2 text-center">
						<Place {place} />
					</div>
				{/each}
			</div>
		</div>
	{/if}
	{#if data.feed.length > 0}
		<h2 class="h4 mt-5 light-text">Latest feed posts</h2>
		<div id="feed" class="light-text p-3">
			<div class="row">
				{#each data.feed.sort((a, b) => b.posted - a.posted) as status}
					<div class="p-2 col-md-6 col-sm-12">
						<div class="card">
							<div class="card-body pb-0">
								<div id="user" class="d-flex mb-2">
									<span class="pfp rounded-circle">
										<img src={data.img} alt={data.displayname} class="rounded-circle img-fluid rounded-top-0" />
									</span>
									<span class="fw-bold ms-3 light-text">{data.displayname}</span>
									<span class="ms-auto fw-italic light-text text-end">{status.posted.toLocaleString()}</span>
								</div>
								<p class="text-start">
									{status.content}
								</p>
							</div>
						</div>
					</div>
				{/each}
			</div>
		</div>
	{/if}
</div>

<style lang="sass">
	#all
		max-width: 60rem

	#image-background
		width: 10rem
		height: 10rem
		background: var(--accent)
		img
			height: 10rem

	.card
		background: var(--accent)

	#feed
		#user
			align-items: center
			.pfp
				background: var(--accent2)
				img
					width: 2rem
</style>
