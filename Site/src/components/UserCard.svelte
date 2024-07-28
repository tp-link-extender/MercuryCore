<script lang="ts">
	import User from "$components/User.svelte"
	import fade from "$lib/fade"

	export let user: BasicUser
	export let num: number
	export let total: number
</script>

<a
	in:fade|global={{ num, total, max: 12 }}
	class="card bg-darker light-text h-full w-full max-w-100 flex flex-row no-underline"
	href="/user/{user.username}">
	<div class="p-6 flex">
		<User {user} image size="6rem" bg="accent" />
	</div>
	<p class="w-fit break-all text-base p-6">
		{user.username}
	</p>
</a>
