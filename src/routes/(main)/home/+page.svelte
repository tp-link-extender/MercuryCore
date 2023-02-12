<script lang="ts">
	import type { PageData } from "./$types"
	import { enhance } from "$app/forms"
	import { getUser } from "@lucia-auth/sveltekit/client"
	import Place from "$lib/components/Place.svelte"
	const user = getUser()

	// explicitly any to prevent warnings
	const statusColours: any = {
		Online: "bg-info",
		Joined: "bg-success",
		Developing: "bg-warning",
	}

	const greets = [`Hi, ${$user?.displayname}!`, `Hello, ${$user?.displayname}!`]

	const news = [
		{ time: new Date(), title: "Mercury is now life!", content: "Mercury is now live! We have a lot of features in store for you, so stay tuned!" },
		{ time: new Date(), title: "Mercury is now life!", content: "Yes" },
		{ time: new Date(), title: "Mercury is now life!", content: "Mercury is now live! We have a lot of features in store for you, so stay tuned!" },
		{ time: new Date(), title: "Mercury now has Free Rocks", content: "Click here for Free Rocks!" },
		{ time: new Date(), title: "Mercury", content: "Pls can i have invite ke" },
		{
			time: new Date(),
			title: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
			content: "Mercury is now live! We have a lot of features in store for you, so stay tunedeoeeeeeeeeeeeeeeeeeeeeee! eeeeeeeeeeeeeeeeeeeeeeeeeee eeeee",
		},
		{ time: new Date(), title: "Mercury is now life!", content: "Mercury is now live! We have a lot of features in store for you, so stay tuned!" },
		{ time: new Date(), title: "Mercury is now love!", content: "Yes" },
	]

	export let data: PageData
	export let form: any
</script>

<svelte:head>
	<title>Home - Mercury</title>
</svelte:head>

<div class="container">
	<div class="row">
		<div class="col col-12 col-xxl-4 col-xl-5 col-md-6 col-sm-12">
			<div class="top d-flex px-2">
				<div class="pfp rounded-circle align-middle">
					<img src={$user?.image} alt="You" class="rounded-circle img-fluid rounded-top-0" />
				</div>
				<h1 class="text-center light-text">
					{greets[Math.floor(Math.random() * greets.length)]}
				</h1>
			</div>
			<div id="feed" class="card mt-4">
				<div class="card-body light-text overflow-auto">
					<p>Post your status - your friends and followers can view how you're doing!</p>
					<form method="POST" use:enhance>
						<div class="input-group">
							<input type="text" class="form-control light-text {form?.msg ? 'is-invalid' : 'valid'}" placeholder="Post status" name="status" aria-label="Post Status" required />
							<button class="btn btn-success" type="submit" id="button-addon2">Send</button>
						</div>
						{#if form?.msg}
							<div class="text-danger">{form.msg}</div>
						{/if}
						<div class="mb-3" />
					</form>
					{#if data.feed.length > 0}
						{#each data.feed.sort((a, b) => b.posted - a.posted) as status}
							<div class="card mb-2">
								<div class="card-body pb-0">
									<a class="d-flex mb-2 text-decoration-none user" href="/user/{status.author.number}">
										<span class="pfp rounded-circle">
											<img src={status.author.image} alt={status.author.displayname} class="rounded-circle img-fluid rounded-top-0" />
										</span>
										<span class="fw-bold ms-3 light-text">{status.author.displayname}</span>
										<span class="ms-auto fw-italic light-text text-end">{status.posted.toLocaleString()}</span>
									</a>
									<p class="text-start">
										{status.content}
									</p>
								</div>
							</div>
						{/each}
					{/if}
				</div>
			</div>
		</div>

		<div class="col col-12 col-xxl-4 col-xl-7 col-md-6">
			<div class="col2">
				{#if data.friends.length > 0}
					<h2 class="h4 light-text">Friends</h2>
					<div class="home-row d-flex">
						{#each data.friends as friend}
							<a class="px-2 mb-2 text-center light-text text-decoration-none" href="/user/{friend.number}">
								<div class="position-relative mb-2">
									<div class="image-background rounded-circle">
										<img src={friend.image} alt={friend.displayname} class="h-100 rounded-circle img-fluid rounded-top-0" />
									</div>
									{#if friend.status}
										<span class="position-absolute bottom-0 end-0 badge rounded-circle {statusColours[friend.status]}">
											<span class="visually-hidden">{friend.status}</span>
										</span>
									{/if}
								</div>
								{friend.displayname}
							</a>
						{/each}
					</div>
				{/if}
			</div>
			<div class="mt-5">
				<h2 class="h4 light-text">Resume playing</h2>
				<div class="home-row d-flex">
					<div class="home-row d-flex">
						{#each data.places || [] as place}
							<div class="px-2 mb-2">
								<div class="place">
									<Place {place} />
								</div>
							</div>
						{/each}
					</div>
				</div>
			</div>
		</div>
		<div class="col col-xxl-4">
			<div class="col2">
				<h2 class="h4 light-text">News</h2>
				<div id="news" class="card">
					<div class="card-body row overflow-auto">
						{#each news as thing}
							<div class="p-1 col-xxl-6 col-lg-4 col-sm-6">
								<div class="card light-text h-100">
									<div class="card-body p-2">
										<div class="mb-2 light-text">
											<div class="fw-bold text-center text-truncate">{thing.title}</div>
											<div id="date" class="ms-auto fw-italic text-center">{thing.time.toLocaleString()}</div>
										</div>
										<div id="gradient" class="position-absolute bottom-0 rounded-2" />
										<p id="content" class="mb-0 p-1">
											{thing.content}
										</p>
									</div>
								</div>
							</div>
						{/each}
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<style lang="sass">
	.container
		max-width: 120rem

	.top
		width: 100vw
		.pfp
			background: var(--accent)
			width: 6rem
			height: 6rem
		h1
			margin: auto 2rem

	.col2
		margin-top: 7rem

	.card
		background: var(--accent)

	#news
		#date
			min-width: 5rem
		#content
			max-height: 5rem
			overflow: hidden
		#gradient
			left: 0
			right: 0
			height: 8rem
			background: linear-gradient(0deg, var(--accent) 10%, rgba(0,0,0,0) 100%)

	#feed, #news
		background: var(--darker)
		max-height: 55vh

	#feed
		.user
			align-items: center
			.pfp
				background: var(--accent2)
				img
					width: 2rem

	.home-row
		overflow-x: auto

		.badge
			padding: 0.75rem
		.place
			width: 8rem
			margin: auto
		.image-background
			background: var(--accent)
			width: 7rem
			margin: auto
</style>
