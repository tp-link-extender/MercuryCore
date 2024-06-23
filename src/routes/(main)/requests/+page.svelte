<script lang="ts">
	import { enhance } from "$app/forms"
	import Head from "$lib/components/Head.svelte"
	import User from "$lib/components/User.svelte"
	import fade from "$lib/fade"

	export let data
</script>

<Head title="Friend requests" />

<h1 class="text-center">Friend requests ({data.users.length})</h1>

<div class="ctnr pt-8 grid">
	{#each data.users as user, num}
		<div
			in:fade|global={{ num, total: data.users.length, max: 12 }}
			class="card bg-darker w-full">
			<div class="flex p-6">
				<User {user} size="6rem" bg="accent" />
				<a
					class="pl-12 text-xl text-white no-underline"
					href="/user/{user.number}">
					{user.username}
				</a>
			</div>
			<div class="flex gap-2 px-2">
				<form
					class="w-full"
					method="POST"
					use:enhance
					action="/user/{user.number}?/accept">
					<button class="btn btn-info w-full">Accept</button>
				</form>
				<form
					class="w-full"
					method="POST"
					use:enhance
					action="/user/{user.number}?/decline">
					<button class="btn btn-danger w-full">Decline</button>
				</form>
			</div>
		</div>
	{/each}
</div>

<style>
	.ctnr {
		max-width: 100%;
		font-size: 0.9rem;
		grid-template-columns: repeat(auto-fit, minmax(16rem, 1fr));
		column-gap: 1rem;
		row-gap: 1rem;
		place-items: center;
	}

	.card {
		max-width: 25rem;
		text-decoration: none;
		& div {
			word-break: break-all;
		}
	}
</style>
