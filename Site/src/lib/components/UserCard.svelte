<script lang="ts">
	import User from "$lib/components/User.svelte"
	import fade from "$lib/fade"

	export let user: BasicUser
	export let num: number
	export let total: number
</script>

<a
	in:fade|global={{ num, total, max: 12 }}
	class="card light-text h-full w-full flex flex-row bg-darker"
	href="/user/{user.username}">
	<div class="p-6 flex">
		<User {user} image size="6rem" bg="accent" />
	</div>
	<p class="text-base p-6">
		{user.username}
	</p>
</a>

<style>
	.card {
		max-width: 25rem;
		text-decoration: none;
		& p {
			width: fit-content;
			word-break: break-all;
		}
	}
</style>
