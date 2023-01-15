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

<main class="container">
	<div class="d-flex px-4">
		<div id="image-background" class="me-4 rounded-circle">
			<img src={data.img} alt={data.displayname} class="rounded-circle rounded-top-0" />
		</div>
		<div class="container">
			<h1 class="light-text d-inline">{data.displayname}</h1>
			<h5 class="d-inline light-text m-2 ps-3 opacity-50">@{data.username}</h5>
			{#if data.bio}
				<em class="light-text d-block mt-4">"{data.bio}"</em>
			{:else}
				<br />
				<br />
			{/if}
			<br />
			<div class="d-flex">
				<div class="light-text text-center">
					Followers
					<h4 class="light-text">
						{data.followerCount}
					</h4>
				</div>
				<div class="light-text text-center ms-4">
					Friends
					<h4 class="light-text">
						{data.friendCount}
					</h4>
				</div>
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
			<h4 class="light-text">Creations</h4>
			<div class="row m-0 p-0">
				{#each data.places as place}
					<div class="col col-4 col-sm-3 col-md-2 text-center">
						<Place {place} />
					</div>
				{/each}
			</div>
		</div>
	{/if}
</main>

<style lang="sass">
	main 
		width: 60rem

	#image-background
		width: 10rem
		height: 10rem
		background: var(--accent2)
		img
			height: 10rem
</style>
