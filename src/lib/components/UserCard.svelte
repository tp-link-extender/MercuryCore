<script lang="ts">
	export let user: {
		number: number
		status: "Playing" | "Online" | "Offline"
		username: string
	}
	export let num: number
	export let total: number
</script>

<a
	in:fade|global={{ num, total, max: 12 }}
	class="card light-text h-100 w-100 d-flex flex-row bg-darker"
	href="/user/{user.number}">
	<div class="p-6 d-flex">
		<User {user} image size="6rem" bg="accent" />
	</div>
	<p class="fs-4 p-6">
		{user.username}
	</p>
</a>

<style lang="stylus">
	.card
		max-width 25rem
		text-decoration none
		p
			width fit-content
			word-break break-all
</style>
