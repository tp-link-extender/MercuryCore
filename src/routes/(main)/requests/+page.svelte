<script lang="ts">
	export let data
</script>

<Head title="Friend requests" />

<h1 class="text-center">Friend requests ({data.users.length})</h1>

<div class="ctnr pt-8 grid">
	{#each data.users as user, num}
		<div
			in:fade|global={{ num, total: data.users.length, max: 12 }}
			class="card bg-darker w-100">
			<div class="flex p-6">
				<User {user} size="6rem" bg="accent" />
				<a
					class="ps-12 fs-3 text-light no-underline"
					href="/user/{user.number}">
					{user.username}
				</a>
			</div>
			<div class="flex gap-2 px-2">
				<form
					class="w-100"
					method="POST"
					use:enhance
					action="/user/{user.number}?/accept">
					<button class="btn btn-info w-100">Accept</button>
				</form>
				<form
					class="w-100"
					method="POST"
					use:enhance
					action="/user/{user.number}?/decline">
					<button class="btn btn-danger w-100">Decline</button>
				</form>
			</div>
		</div>
	{/each}
</div>

<style lang="stylus">
	.ctnr
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
