<script lang="ts">
	export let data
</script>

<Head title="Friend requests" />

<h1 class="text-center">Friend requests ({data.users.length})</h1>

<div class="container mt-12 d-grid">
	{#each data.users as user, num}
		<div
			in:fade|global={{ num, total: data.users.length, max: 12 }}
			class="card bg-darker h-100 w-100 d-flex flex-col">
			<div class="d-flex flex-row p-6">
				<User {user} size="6rem" bg="accent" />
				<a
					class="ps-12 fs-4 text-light text-decoration-none"
					href="/user/{user.number}">
					{user.username}
				</a>
			</div>
			<form
				class="align-self-center row w-100 p-2 pt-0"
				method="POST"
				use:enhance
				action="/user/{user.number}?/interact">
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

<style lang="stylus">
	.container
		max-width 100%
		font-size 0.9rem

		grid-template-columns repeat(auto-fit, minmax(16rem, 1fr))
		column-gap 1rem
		row-gap 1rem
		place-items center

	.card
		max-width 25rem
		text-decoration none
		div
			word-break break-all
</style>
