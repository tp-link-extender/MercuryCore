<script lang="ts">
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import Head from "$components/Head.svelte"
	import Place from "$components/Place.svelte"
	import User from "$components/User.svelte"
	import fade from "$lib/fade"
	import { superForm } from "$lib/validate"
	import Status from "./Status.svelte"

	const { data } = $props()

	let { user } = $derived(data)
	let formData = $derived(superForm(data.form))
	export const snapshot = formData
</script>

<Head name={data.siteName} title="Home" />

<!-- Flex or Grid? what a dilemma -->
<div class="ctnr lg:grid grid-cols-2 gap-4">
	<div>
		<h1 class="w-full flex px-10 pb-6 my-0 <sm:text-2xl">
			<a
				href="/user/{user.username}"
				class="no-underline flex items-center">
				<User {user} size="6rem" bg="accent" image class="<sm:hidden" />
				<User {user} size="4rem" bg="accent" image class="sm:hidden" />
				<span class="pl-6">
					{data.greet}
				</span>
			</a>
		</h1>
		<div
			class="card bg-darker rounded-2 p-4 <lg:max-h-50vh overflow-x-hidden lg:overflow-y-hidden">
			<p>
				Post your status &ndash; your friends and followers can view how
				you're doing!
			</p>
			<Form
				{formData}
				inline
				nopad
				submit="<fa fa-paper-plane-top></fa>"
				working="...">
				<Input
					{formData}
					inline
					name="status"
					placeholder="Post a status" />
			</Form>
			{#if data.feed.length > 0}
				<div class="flex flex-col gap-3 pt-3">
					{#each data.feed as status, num (status.id)}
						<div
							in:fade|global={{
								num,
								total: data.feed.length
							}}>
							<Status {status} />
						</div>
					{/each}
				</div>
			{:else}
				<div class="p-4 pb-2">
					No status posts yet. Be the first to post one!
				</div>
			{/if}
		</div>
	</div>

	<div class="pt-12 lg:pt-28 pl-2 flex flex-col gap-12">
		{#if data.friends.length > 0}
			<div>
				<h2 class="pb-2">Friends</h2>
				<div class="flex overflow-x-auto gap-4">
					{#each data.friends as friend, num}
						<!-- Larger delay between fades for more items -->
						<span
							in:fade|global={{
								num,
								total: data.friends.length
							}}>
							<User
								user={friend}
								size="7rem"
								bg="accent"
								bottom />
						</span>
					{/each}
				</div>
			</div>
		{/if}
		{#if data.places.length > 0}
			<div>
				<h2 class="pb-2">Resume playing</h2>
				<div class="flex overflow-x-auto gap-4">
					{#each data.places || [] as place, num}
						<div class="min-w-32 w-32">
							<Place {place} {num} total={data.places.length} />
						</div>
					{/each}
				</div>
			</div>
		{/if}
	</div>
</div>
