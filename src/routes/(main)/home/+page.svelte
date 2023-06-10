<script lang="ts">
	import { page } from "$app/stores"
	import fade from "$lib/fade"
	import Place from "$lib/components/Place.svelte"
	import Report from "$lib/components/Report.svelte"
	import { superForm } from "sveltekit-superforms/client"

	// const statusColours: { [k: string]: string } = {
	// 	Online: "bg-info",
	// 	Joined: "bg-emerald-500",
	// 	Developing: "bg-warning",
	// }

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

	const greets = [`Hi, ${user.username}!`, `Hello, ${user.username}!`]

	const news = [
		{
			time: new Date(),
			title: "Mercury is now life!",
			content:
				"Mercury is now live! We have a lot of features in store for you, so stay tuned!",
		},
		{ time: new Date(), title: "Mercury is now life!", content: "Yes" },
		{
			time: new Date(),
			title: "Mercury is now life!",
			content:
				"Mercury is now live! We have a lot of features in store for you, so stay tuned!",
		},
		{
			time: new Date(),
			title: "Mercury now has Free Rocks",
			content: "Click here for Free Rocks!",
		},
		{
			time: new Date(),
			title: "Mercury",
			content: "Pls can i have invite ke",
		},
		{
			time: new Date(),
			title: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
			content:
				"Mercury is now live! We have a lot of features in store for you, so stay tunedeoeeeeeeeeeeeeeeeeeeeeee! eeeeeeeeeeeeeeeeeeeeeeeeeee eeeee",
		},
		{
			time: new Date(),
			title: "Mercury is now life!",
			content:
				"Mercury is now live! We have a lot of features in store for you, so stay tuned!",
		},
		{ time: new Date(), title: "Mercury is now love!", content: "Yes" },
	]

	const facts = [
		`You joined mercury on ${user?.accountCreated
			.toLocaleString()
			.substring(0, 10)}!`,
		// Add "st", "nd", "rd", "th" to number
		`You are the ${user?.number}${
			["st", "nd", "rd"][(user?.number % 10) - 1] || "th"
		} user to join Mercury!`,
	]
</script>

<svelte:head>
	<title>Home - Mercury</title>
</svelte:head>

<div class="container">
	<div class="grid grid-cols-12 gap-6">
		<div
			class="col col-span-12 xxl:col-span-6 xl:col-span-5 md:col-span-6 sm:col-span-12">
			<h1 class="top flex px-2">
				<a
					href="/user/{user?.number}"
					class="no-underline light-text flex">
					<div class="bg-a rounded-full">
						<img
							src="/api/avatar/{user?.username}"
							alt="You"
							class="rounded-full rounded-top-0" />
					</div>
					<span class="my-auto ms-4">
						{greets[Math.floor(Math.random() * greets.length)]}
					</span>
				</a>
			</h1>
			<div id="feed" class="card mt-4 bg-darker">
				<div class="card-body light-text">
					<p>
						Post your status - your friends and followers can view
						how you're doing!
					</p>
					<form use:enhance method="POST" class="flex">
						<input
							bind:value={$form.status}
							{...$constraints.status}
							placeholder="Post status"
							name="status"
							aria-label="Post Status"
							class="form-control light-text {$errors.status
								? 'is-in'
								: ''}valid" />
						<button
							class="btn bg-emerald-600 hover:bg-emerald-800 text-white"
							type="submit"
							aria-label="Send">
							{#if $delayed}
								...
							{:else}
								<i class="fa fa-paper-plane-top" />
							{/if}
						</button>
					</form>
					<p
						class="mb-3"
						class:text-emerald-500={$page.status == 200}
						class:text-red-500={$page.status >= 400 ||
							$errors.status}>
						{$errors.status || $message || ""}
					</p>
					{#each data.feed.sort((a, b) => b.posted.getTime() - a.posted.getTime()) as status, num}
						<!-- |global is not mentioned anywhere in the Svelte docs, yet it is exactly what is needed here. -->
						<div
							in:fade|global={{ num, total: data.feed.length }}
							class="card mb-2">
							<div class="card-body pb-0 p-3">
								<div class="flex mb-2 user inline">
									<a
										href="/user/{status.authorUser?.number}"
										class="no-underline flex items-center light-text">
										<span
											class="bg-background rounded-full">
											<img
												src="/api/avatar/{status
													.authorUser?.username}"
												alt={status.authorUser
													?.username}
												class="rounded-full rounded-top-0" />
										</span>
										<span
											class="username mw-50 font-bold ms-3">
											{status.authorUser?.username}
										</span>
										<em class="small ms-3">
											{status.posted.toLocaleString()}
										</em>
									</a>
									<span class="ms-auto">
										<Report
											user={status.authorUser?.username ||
												""}
											url="status:{status.id}" />
									</span>
								</div>
								<p class="text-start">
									{status.content}
								</p>
							</div>
						</div>
					{/each}
				</div>
			</div>
		</div>

		<div class="col col-span-12 xxl:col-span-6 xl:col-span-7 md:col-span-6">
			<div class="col2">
				{#if data.friends.length > 0}
					<h2 class="h4 light-text">Friends</h2>
					<div class="home-row flex">
						{#each data.friends as friend, num}
							<!-- Larger delay between fades for more items -->
							<a
								in:fade={{ num, total: data.friends.length }}
								class="px-2 mb-2 text-center light-text no-underline"
								href="/user/{friend.number}">
								<div class="relative mb-2">
									<div
										class="image-background bg-a rounded-full">
										<img
											src="/api/avatar/{friend.username}"
											alt={friend.username}
											class="h-100 rounded-full rounded-top-0" />
									</div>
									<!-- {#if friend.status}
										<span
											class="absolute bottom-0 end-0 badge rounded-full {statusColours[
												friend.status
											]}">
											<span class="visually-hidden">
												{friend.status}
											</span>
										</span>
									{/if} -->
								</div>
								<p
									class="friendname username"
									class:small={friend.username.length > 15}>
									{friend.username}
								</p>
							</a>
						{/each}
					</div>
				{/if}
			</div>
			<div class="mt-5">
				<h2 class="h4 light-text">Resume playing</h2>
				<div class="home-row flex">
					<div class="home-row flex">
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
			<div class="mt-5 col-span-12">
				<h2 class="h4 light-text">News</h2>
				<div id="news" class="card bg-darker">
					<div class="card-body row">
						{#each news as thing, num}
							<div
								in:fade={{ num, total: news.length }}
								class="p-1 xl:col-span-4 lg:col-span-6 col-span-12">
								<div class="card light-text h-100">
									<div class="card-body p-2">
										<div class="mb-2 light-text">
											<div
												class="font-bold text-center truncate">
												{thing.title}
											</div>
											<div
												class="date ms-auto fw-italic text-center">
												{thing.time.toLocaleString()}
											</div>
										</div>
										<div
											class="gradient absolute bottom-0 rounded-2" />
										<p class="content mb-0 p-1">
											{thing.content}
										</p>
									</div>
								</div>
							</div>
						{/each}
					</div>
				</div>
			</div>
			<div
				class="mt-5 col-span-6 md:col-span-8 lg:col-span-6 xl:col-span-4">
				<h2 class="h4 light-text">Random fact</h2>
				<div
					id="fact"
					class="card bg-darker card-body light-text h5 pb-4">
					{facts[Math.floor(Math.random() * facts.length)]}
				</div>
			</div>
		</div>
	</div>
</div>

<style lang="sass">
	@media only screen and (max-width: 768px)
		#feed
			max-height: 50vh
	.top
		width: 100vw
		img
			width: 6rem
			min-width: 6rem

	h1
		margin: auto 2rem

	.col2
		margin-top: 7rem

	.username
		overflow: hidden
		text-overflow: ellipsis
		white-space: nowrap

	.small
		font-size: 0.9rem

	.friendname
		max-width: 7rem
		max-height: 3rem

	.date
		min-width: 5rem
	.gradient
		left: 0
		right: 0
		height: 8rem
		background: linear-gradient(0deg, var(--accent) 10%, rgba(0,0,0,0) 100%)
	.content
		max-height: 5rem
		overflow: hidden

	#feed, #news
		overflow-x: hidden

	.user
		align-items: center
		img
			width: 2rem !important
			min-width: 2rem !important

	.home-row
		overflow-x: auto

		// .badge
		// 	padding: 0.75rem
		.place
			width: 8rem
			margin: auto
		.image-background
			width: 7rem
			height: 7rem
			margin: auto
</style>
