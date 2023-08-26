<script lang="ts">
	// const statusColours: { [k: string]: string } = {
	// 	Online: "bg-info",
	// 	Joined: "bg-emerald-500",
	// 	Developing: "bg-warning",
	// }

	export let data
</script>

<Head title="Friend requests" />

<h1 class="light-text text-center">Friend requests ({data.number})</h1>

<div class="container mt-12 d-grid">
	{#each data.users as user, num}
		<div
			in:fade|global={{ num, total: data.users.length, max: 12 }}
			class="card bg-darker light-text h-100 w-100 d-flex flex-col">
			<div class="d-flex flex-row">
				<a class="p-6 pe-2" href="/user/{user.number}">
					<div class="image-background bg-a rounded-circle">
						<img
							src="/api/avatar/{user.username}"
							alt={user.username}
							class="h-100 rounded-full rounded-top-0" />
					</div>
					<!-- {#if user.status}
						<span
							class="absolute bottom-0 end-0 badge rounded-full {statusColours[
								user.status
							]}">
						</span>
					{/if} -->
				</a>
				<div class="h4 p-6">
					<a
						href="/user/{user.number}"
						class="no-underline light-text">
						{user.username}
					</a>
				</div>
			</div>
			<form
				class="self-center row w-100 p-2 pt-0"
				method="POST"
				use:enhance
				action="/user/{user.number}">
				<button
					name="action"
					value="accept"
					class="btn bg-cyan-600 hover:bg-cyan-800 text-white me-1 col">
					Accept
				</button>
				<button
					name="action"
					value="decline"
					class="btn bg-red-500 ms-1 col">
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

	// .badge
	// 	padding 0.75rem
	.image-background
		min-width 6rem
		img
			width 6rem
			height 6rem !important
</style>
