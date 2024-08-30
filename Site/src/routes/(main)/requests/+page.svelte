<script lang="ts">
	import { enhance } from "$app/forms"
	import { page } from "$app/stores"
	import Head from "$components/Head.svelte"
	import Pagination from "$components/Pagination.svelte"
	import User from "$components/User.svelte"
	import fade from "$lib/fade"

	export let data
</script>

<Head name={data.siteName} title="Friend requests" />

<h1 class="text-center">Friend requests ({data.users.length})</h1>

<div class="ctnr pt-8">
	{#if data.users.length > 0}
		<div class="grid max-w-300 mx-auto">
			{#each data.users as user, num}
				<div
					in:fade|global={{ num, total: data.users.length, max: 12 }}
					class="card bg-darker w-full">
					<div class="flex p-6">
						<User {user} size="6rem" bg="accent" />
						<a
							class="pl-12 text-xl text-white no-underline"
							href="/user/{user.username}">
							{user.username}
						</a>
					</div>
					<div class="flex gap-2 px-2">
						<form
							use:enhance
							method="POST"
							action="/user/{user.username}?/accept"
							class="w-full">
							<button class="btn btn-secondary w-full">
								Accept
							</button>
						</form>
						<form
							use:enhance
							method="POST"
							action="/user/{user.username}?/decline"
							class="w-full">
							<button class="btn btn-red-secondary w-full">
								Decline
							</button>
						</form>
					</div>
				</div>
			{/each}
		</div>
		{#key $page.url}
			<Pagination totalPages={data.pages} />
		{/key}
	{:else}
		<h2 class="pt-12 text-center">No friend requests found</h2>
	{/if}
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
