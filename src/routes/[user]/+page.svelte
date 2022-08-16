<script lang="ts">
	throw new Error("@migration task: Add data prop (https://github.com/sveltejs/kit/discussions/5774#discussioncomment-3292707)");

	export let user: any
</script>

<svelte:head>
	<title>{user.name} - Mercury</title>
</svelte:head>

<main class="container">
	<div class="d-flex px-4">
		<div id="image-background" class="me-4">
			<img src={user.img} alt={user.name} />
		</div>
		<div class="container">
			<div>
				<h1 class="light-text">{user.name}</h1>
				<em class="light-text">"{user.bio}"</em>
			</div>
			<br />
			<div class="d-flex">
				<div class="light-text text-center">
					Followers
					<h4 class="light-text">
						{user.followerCount}
					</h4>
				</div>
				<div class="light-text text-center ms-4">
					Friends
					<h4 class="light-text">
						{user.friendCount}
					</h4>
				</div>
				<div class="align-self-center ms-auto me-2">
					<button
						type="button"
						on:click={() => {
							if (user.friends) {
								user.friends = false
								user.friendCount -= 1
							} else {
								user.pendingRequest = !user.pendingRequest
							}
						}}
						class={`btn ${user.friends || user.pendingRequest ? "btn-danger" : "btn-success"}`}
					>
						{#if user.friends}
							Unfriend
						{:else if user.pendingRequest == true}
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
							user.following = !user.following
							user.followerCount += user.following ? 1 : -1
						}}
						class={`btn ${user.following ? "btn-danger" : "btn-primary"}`}
					>
						{#if user.following}
							Unfollow
						{:else}
							Follow
						{/if}
					</button>
				</div>
			</div>
		</div>
	</div>
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
			border-radius: 100%
			height: 10rem
</style>
