<script lang="ts">
	import { page } from "$app/stores"
	import { superForm } from "sveltekit-superforms/client"
	import Status from "./Status.svelte"

	export let data
	const { user } = data,
		{
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

<div class="container">
	<div class="row">
		<div class="col col-12 col-xxl-6 col-xl-5 col-md-6 col-sm-12">
			<h1 class="top d-flex px-2 pb-6">
				<a
					href="/user/{user?.number}"
					class="text-decoration-none light-text d-flex">
					<User {user} size="6rem" bg="accent" image />
					<span class="my-auto ms-6">
						{data.stuff.greet}
					</span>
				</a>
			</h1>
			<div id="feed" class="card p-4 bg-darker">
					<p>
						Post your status - your friends and followers can view
						how you're doing!
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
								<i class="fa fa-paper-plane-top" />
							{/if}
						</button>
					</form>
					<p
					class="mb-0 pb-3"
						class:text-success={$page.status == 200}
						class:text-danger={$page.status >= 400 ||
							$errors.status}>
						{$errors.status || $message || ""}
					</p>
					<div class="d-flex flex-column gap-3">
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

		<div class="col col-12 col-xxl-6 col-xl-7 col-md-6">
			<div class="col2 pt-28">
				{#if data.friends.length > 0}
					<h2 class="fs-4 light-text">Friends</h2>
					<div class="home-row d-flex">
						{#each data.friends as friend, num}
							<!-- Larger delay between fades for more items -->
							<span
								class="px-2"
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
				{/if}
			</div>
			<div class="pt-12">
				<h2 class="fs-4 light-text">Resume playing</h2>
				<div class="home-row d-flex">
					<div class="home-row d-flex">
						{#each data.places || [] as place, num}
							<div class="px-2 mb-2">
								<div class="place">
									<Place
										{place}
										{num}
										total={data.places.length} />
								</div>
							</div>
						{/each}
					</div>
				</div>
			</div>
			<div class="pt-12 col-6 col-md-8 col-lg-6 col-xl-4">
				<h2 class="fs-4 light-text">Random fact</h2>
				<div
					id="fact"
					class="card bg-darker card-body light-text fs-5 pb-6">
					{data.stuff.fact}
				</div>
			</div>
		</div>
	</div>
</div>

<style lang="stylus">
	+-md()
		#feed
			max-height 50vh
		.col2
			margin-top 3rem !important

	.top
		width 100vw

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

	.home-row
		overflow-x auto

		.place
			width 8rem
			margin auto
</style>
