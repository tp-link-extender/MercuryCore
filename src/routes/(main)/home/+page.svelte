<script lang="ts">
	import { page } from "$app/stores"
	import { superForm } from "sveltekit-superforms/client"
	import Status from "./Status.svelte"

	export let data
	const { user } = data
	const {
		form,
		errors,
		message,
		constraints,
		enhance,
		delayed,
		capture,
		restore,
	} = superForm(data.form, {
		taintedMessage: false,
	})

	export const snapshot = { capture, restore }
</script>

<Head title="Home" />

<div class="ctnr">
	<div class="flex flex-wrap">
		<div class="w-full md:w-1/2 pr-2">
			<h1 class="w-screen flex px-2 pb-6">
				<a
					href="/user/{user?.number}"
					class="no-underline light-text flex items-center">
					<User {user} size="6rem" bg="accent" image />
					<span class="ml-6">
						{data.stuff.greet}
					</span>
				</a>
			</h1>
			<div id="feed" class="card p-4 bg-darker <md:h-50vh">
				<p>
					Post your status - your friends and followers can view how
					you're doing!
				</p>
				<form use:enhance method="POST" class="input-group">
					<input
						bind:value={$form.status}
						{...$constraints.status}
						placeholder="Post status"
						name="status"
						aria-label="Post Status"
						class="form-control light-text {$errors.status
							? 'is-in'
							: ''}valid" />
					<button class="btn btn-success" aria-label="Send">
						{#if $delayed}
							...
						{:else}
							<fa fa-paper-plane-top />
						{/if}
					</button>
				</form>
				<p
					class="mb-0 pb-3"
					class:text-success={$page.status == 200}
					class:text-danger={$page.status >= 400 || $errors.status}>
					{$errors.status || $message || ""}
				</p>
				<div class="flex flex-col gap-3">
					{#each data.feed.sort((a, b) => new Date(b.posted).getTime() - new Date(a.posted).getTime()) as status, num}
						<div
							in:fade|global={{
								num,
								total: data.feed.length,
							}}>
							<Status {status} />
						</div>
					{/each}
				</div>
			</div>
		</div>

		<div class="pt-12 md:pt-28 pl-2 flex gap-12 flex-col w-1/2">
			{#if data.friends.length > 0}
				<div>
					<h2 class="light-text">Friends</h2>
					<div class="home-row flex overflow-x-auto gap-4">
						{#each data.friends as friend, num}
							<!-- Larger delay between fades for more items -->
							<span
								in:fade|global={{
									num,
									total: data.friends.length,
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
			<div>
				<h2 class="light-text">Resume playing</h2>
				<div class="home-row flex overflow-x-auto gap-4">
					{#each data.places || [] as place, num}
						<div class="min-w-32 w-32">
							<Place {place} {num} total={data.places.length} />
						</div>
					{/each}
				</div>
			</div>
			<div class="w-1/2 cmd:w-2/3 lg:w-1/2 xl:w-2/3">
				<h2 class="light-text">Random fact</h2>
				<div
					id="fact"
					class="card bg-darker card-body light-text text-base pb-6">
					{data.stuff.fact}
				</div>
			</div>
		</div>
	</div>
</div>

<style lang="stylus">

	h1
		margin auto 2rem

	.username
		overflow hidden
		text-overflow ellipsis
		white-space nowrap

	.small
		font-size 0.9rem

	.friendname
		max-width 7rem
		max-height 3rem

	.date
		min-width 5rem
	.gradient
		left 0
		right 0
		height 8rem
		background linear-gradient(0deg, var(--accent) 10%, rgba(0,0,0,0) 100%)
	.content
		max-height 5rem
		overflow hidden

	#feed
	#news
		overflow-x hidden
</style>
