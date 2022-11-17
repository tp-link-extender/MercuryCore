<script lang="ts">
	export let data: any
</script>

<svelte:head>
	<title>{data.displayname} - Mercury</title>
</svelte:head>

<main class="container">
	<div class="d-flex px-4">
		<div id="image-background" class="me-4">
			<img src={data.img} alt={data.displayname} />
		</div>
		<div class="container">
			<h1 class="light-text d-inline">{data.displayname}</h1>
			<h5 id="username" class="d-inline light-text m-2 ps-3 ">@{data.username}</h5>
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
				<div class="align-self-center ms-auto me-2">
					<button
						type="button"
						on:click={() => {
							if (data.friends) {
								data.friends = false
								data.friendCount -= 1
							} else {
								data.pendingRequest = !data.pendingRequest
							}
						}}
						class="btn {data.friends || data.pendingRequest ? "btn-danger" : "btn-success"}"
					>
						{#if data.friends}
							Unfriend
						{:else if data.pendingRequest == true}
							Cancel request
						{:else}
							Add friend
						{/if}
					</button>
				</div>
				<div class="align-self-center">
					<button
						type="button"
						on:click={() => {
							data.following = !data.following
							data.followerCount += data.following ? 1 : -1
						}}
						class="btn {data.following ? "btn-danger" : "btn-primary"}"
					>
						{#if data.following}
							Unfollow
						{:else}
							Follow
						{/if}
					</button>
				</div>
			</div>
		</div>
	</div>
	{#if data.places.length > 0}
		<div class="mt-5">
			<h4 class="light-text">Creations</h4>
			<div class="row p-0">
				{#each data.places as place}
					<a class="place col col-4 col-sm-3 col-md-2 text-center light-text px-2" href="/{place.ownerUsername}/{place.name}">
						<img src={place.image} class="mb-2" alt={place.name} />
						{place.name}
					</a>
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
		border-radius: 100%
		img
			border-radius: 0 0 50% 50%
			height: 10rem

	.row
		margin: 0

	.place
		border-radius: 0.5rem
		margin-bottom: 1rem
		text-decoration: none
		img
			width: 100%

	.place img
		border-radius: 0.5rem

	#username
		opacity: 0.5
</style>
