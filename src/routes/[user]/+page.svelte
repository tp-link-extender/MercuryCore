<script lang="ts">
	export let data: any
</script>

<svelte:head>
	<title>{data.name} - Mercury</title>
</svelte:head>

<main class="container">
	<div class="d-flex px-4">
		<div id="image-background" class="me-4">
			<img src={data.img} alt={data.name} />
		</div>
		<div class="container">
			<div>
				<h1 class="light-text">{data.name}</h1>
				<em class="light-text">"{data.bio}"</em>
			</div>
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
						class={`btn ${data.friends || data.pendingRequest ? "btn-danger" : "btn-success"}`}
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
						class={`btn ${data.following ? "btn-danger" : "btn-primary"}`}
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
</style>
