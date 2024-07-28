<script lang="ts">
	import Head from "$components/Head.svelte"
	import Place from "$components/Place.svelte"
	import User from "$components/User.svelte"
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import fade from "$lib/fade"
	import { superForm } from "sveltekit-superforms/client"
	import Status from "./Status.svelte"

	export let data

	const { user } = data
	const formData = superForm(data.form)
	export const snapshot = formData

	$: sortedFeed = data.feed.sort(
		(a, b) => new Date(b.posted).getTime() - new Date(a.posted).getTime()
	)
</script>

<Head title="Home" />

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
			class="card rounded-2 p-4 bg-darker overflow-x-hidden <lg:max-h-50vh">
			<p>
				Post your status &ndash; your friends and followers can view how
				you're doing!
			</p>
			<!-- fa-paper-plane-top (for unocss) -->
			<Form
				{formData}
				inline
				nopad
				submit="<fa fa-paper-plane-top />"
				working="...">
				<Input
					{formData}
					inline
					name="status"
					placeholder="Post a status" />
			</Form>
			{#if sortedFeed.length > 0}
				<div class="flex flex-col gap-3 pt-3">
					{#each sortedFeed as status, num}
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
