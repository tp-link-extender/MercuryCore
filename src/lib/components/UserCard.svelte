<script lang="ts">
	import fade from "$lib/fade"
	import User from "./User.svelte"

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
	class="card light-text h-full w-full flex flex-row bg-darker"
	href="/user/{user.number}">
	<div class="p-6 flex">
		<User {user} image size="6rem" bg="accent" />
	</div>
	<p class="text-base p-6">
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
