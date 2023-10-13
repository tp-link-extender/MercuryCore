<script lang="ts">
	import { page } from "$app/stores"
	import { superForm } from "sveltekit-superforms/client"

	// const statusColours: { [k: string]: string } = {
	// 	Online: "bg-info",
	// 	Joined: "bg-success",
	// 	Developing: "bg-warning",
	// }

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
</script>

<Head title="Home" />

<div class="container">
	<div class="row">
		<div class="col col-12 col-xxl-6 col-xl-5 col-md-6 col-sm-12">
			<h1 class="top d-flex px-2">
				<a
					href="/user/{user?.number}"
					class="text-decoration-none light-text d-flex">
					<User {user} size="6rem" bg="accent" image />
					<span class="my-auto ms-6">
						{data.stuff.greet}
					</span>
				</a>
			</h1>
			<div id="feed" class="card mt-6 bg-darker">
				<div class="card-body light-text">
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
						class="mb-4"
						class:text-success={$page.status == 200}
						class:text-danger={$page.status >= 400 ||
							$errors.status}>
						{$errors.status || $message || ""}
					</p>
					{#each data.feed.sort((a, b) => new Date(b.posted).getTime() - new Date(a.posted).getTime()) as status, num}
						{#if status.authorUser}
							<div
								in:fade|global={{
									num,
									total: data.feed.length,
								}}
								class="card mb-2">
								<div class="card-body pb-0 p-3">
									<div
										class="statusheader d-flex mb-2 user justify-content-between">
										<div class="d-flex align-items-center">
											<User
												user={status.authorUser}
												size="2rem"
												full
												bg="darker" />
										</div>
										<span class="report align-self-center">
											<em
												class="small light-text timestamp">
												{new Date(status.posted).toLocaleString()}
											</em>
											<ReportButton
												user={status.authorUser
													?.username || ""}
												url="status:{status.id}" />
										</span>
									</div>
									<p class="text-start">
										{status.content[0].text}
									</p>
								</div>
							</div>
						{/if}
					{/each}
				</div>
			</div>
		</div>

		<div class="col col-12 col-xxl-6 col-xl-7 col-md-6">
			<div class="col2 mt-28">
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
			<div class="mt-12">
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
			<div class="mt-12 col-12">
				<h2 class="fs-4 light-text">News</h2>
				<div id="news" class="card bg-darker">
					<div class="card-body row">
						{#each news as thing, num}
							<div
								in:fade|global={{ num, total: news.length }}
								class="p-1 col-xl-4 col-lg-6 col-12">
								<div class="card light-text h-100">
									<div class="card-body p-2">
										<div class="mb-2 light-text">
											<div
												class="font-bold text-center text-truncate">
												{thing.title}
											</div>
											<div
												class="date ms-auto italic text-center">
												{thing.time.toLocaleString()}
											</div>
										</div>
										<div
											class="gradient position-absolute bottom-0 rounded-2" />
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
			<div class="mt-12 col-6 col-md-8 col-lg-6 col-xl-4">
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

	+-lg()
		.statusheader
			flex-direction column
		.report
			width 100%
			padding-top 0.5rem
			display flex
			justify-content space-between
			em
				margin 0

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

		// .badge
		// 	padding 0.75rem
		.place
			width 8rem
			margin auto
</style>
