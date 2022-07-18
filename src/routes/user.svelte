<script lang="ts">
	import { page } from "$app/stores"

	const name = $page.url.searchParams.get("name")

	const user = {
		img: "https://tr.rbxcdn.com/10a748f7422e0ef1ed49bdde580cf0ec/150/150/AvatarHeadshot/Png",
		bio: "Cc bag look nice but the birkin bag look way more heavy",
		followerCount: 420,
		friendCount: 21,
		friends: true,
		following: true,
		pendingRequest: false,
	}
</script>

<svelte:head>
	<title>{name} - Mercury</title>
</svelte:head>

<main class="container">
	<div class="d-flex px-4">
		<div id="imagebackground" class="me-4">
			<img src={user.img} alt={name} />
		</div>
		<div class="container">
			<div>
				<h1 class="dark-text">{name}</h1>
				<em class="dark-text">"{user.bio}"</em>
			</div>
			<br />
			<div class="d-flex">
				<div class="dark-text text-center">
					Followers
					<h4 class="dark-text">
						{user.followerCount}
					</h4>
				</div>
				<div class="dark-text text-center ms-4">
					Friends
					<h4 class="dark-text">
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
						class={`btn ${user.following ? "btn-danger" : "btn-success"}`}
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

	#imagebackground
		width: 10rem
		height: 10rem
		background: var(--accent2)
		border-radius: 100%
		img
			border-radius: 100%
			height: 10rem
</style>
