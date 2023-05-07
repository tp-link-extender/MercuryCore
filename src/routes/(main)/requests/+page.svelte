<script lang="ts">
	import { enhance } from "$app/forms"
	import fade from "$lib/fade"

	const statusColours: any = {
		Online: "bg-info",
		Joined: "bg-success",
		Developing: "bg-warning",
	}

	export let data
</script>

<svelte:head>
	<title>Friend requests - Mercury</title>
</svelte:head>

<h1 class="light-text text-center">Friend requests ({data.number})</h1>

<div class="container mt-5 d-grid">
	{#each data.users as user, num}
		<div
			in:fade={{ num, total: data.users.length, max: 12 }}
			class="card bg-darker light-text h-100 w-100 d-flex flex-col">
			<div class="d-flex flex-row">
				<a class="p-4 pe-2" href="/user/{user.number}">
					<div class="image-background bg-a rounded-circle">
						<img
							src="/api/avatar/{user.username}"
							alt={user.username}
							class="h-100 rounded-circle img-fluid rounded-top-0" />
					</div>
					{#if user.status}
						<span
							class="position-absolute bottom-0 end-0 badge rounded-circle {statusColours[
								user.status
							]}">
							<span class="visually-hidden">{user.status}</span>
						</span>
					{/if}
				</a>
				<div class="h4 p-4">
					<a
						href="/user/{user.number}"
						class="text-decoration-none light-text">
						{user.username}
					</a>
				</div>
			</div>
			<form
				class="align-self-center row w-100 p-2 pt-0"
				method="POST"
				use:enhance
				action="/user/{user.number}">
				<button
					name="action"
					value="accept"
					class="btn btn-info me-1 col">
					Accept
				</button>
				<button
					name="action"
					value="decline"
					class="btn btn-danger ms-1 col">
					Decline
				</button>
			</form>
		</div>
	{/each}
</div>

<style lang="sass">
	.container
		max-width: 100%
		font-size: 0.9rem

		grid-template-columns: repeat(auto-fit, minmax(16rem, 1fr))
		column-gap: 1rem
		row-gap: 1rem
		place-items: center

	.card
		max-width: 25rem
		text-decoration: none
		div
			word-break: break-all

	.badge
		padding: 0.75rem
	.image-background
		min-width: 6rem
		img
			width: 6rem
			height: 6rem !important
</style>
