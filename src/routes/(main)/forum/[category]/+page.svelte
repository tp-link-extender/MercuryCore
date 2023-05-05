<script lang="ts">
	import { enhance } from "$app/forms"
	import fade from "$lib/fade"

	export let data
	// Forum
	// data.posts contain each post as {id, content, likes, dislikes, author: {username}}
</script>

<svelte:head>
	<title>{data.name} forum - Mercury</title>
</svelte:head>

<div class="container light-text">
	<h1 class="light-text mb-5">
		{data.name} - Forum
		<a
			href="/forum/create?category={data.name}"
			class="btn btn-primary ms-4">
			<i class="fa fa-file me-2" />
			Create post
		</a>
	</h1>
	{#each data.posts as post, num}
		<div
			in:fade|global={{ num, total: data.posts.length }}
			class="post card bg-darker mb-3 flex-row">
			<form
				use:enhance
				class="sidebar bg-a me-2 p-1"
				method="POST"
				action="?/like">
				<input type="hidden" name="id" value={post.id} />
				<div class="mb-2 d-flex flex-column">
					<div class="text-center">
						<button
							name="action"
							value={post.likes ? "unlike" : "like"}
							aria-label={post.likes ? "Unlike" : "Like"}
							class="btn btn-sm {post.likes
								? 'btn-success'
								: 'btn-outline-success'}">
							{#if post.likes}
								<i class="fa fa-thumbs-up" />
							{:else}
								<i class="far fa-thumbs-up" />
							{/if}
						</button>
					</div>
					<span
						class="my-2 text-center {post.likes
							? 'text-success fw-bold'
							: post.dislikes
							? 'text-danger fw-bold'
							: ''}">
						{post.likeCount - post.dislikeCount}
					</span>
					<div class="text-center">
						<button
							name="action"
							value={post.dislikes ? "undislike" : "dislike"}
							aria-label={post.dislikes ? "Undislike" : "Dislike"}
							class="btn btn-sm {post.dislikes
								? 'btn-danger'
								: 'btn-outline-danger'}">
							{#if post.dislikes}
								<i class="fa fa-thumbs-down" />
							{:else}
								<i class="far fa-thumbs-down" />
							{/if}
						</button>
					</div>
					<!-- <div id="replycount" class="d-flex">
						<div class="mt-auto"><i class="far fa-message" /> {post._count.replies}</div>
					</div> -->
				</div>
			</form>
			<div class="d-flex flex-column w-100">
				<a
					href="/user/{post.author.number}"
					class="user d-flex light-text text-decoration-none m-2 pe-4 mb-0 w-100">
					<span class="pfp bg-a2 rounded-circle me-1">
						<img
							src={post.author.image}
							alt={post.author.username}
							class="rounded-circle rounded-top-0" />
					</span>
					<span class="fw-bold ms-2">
						{post.author.username}
					</span>
					<em class="ms-auto">
						{post.posted.toLocaleString()}
					</em>
				</a>
				<a
					href="/forum/{data.name.toLowerCase()}/{post.id}"
					class="p-3 pb-0 text-decoration-none light-text w-100">
					<h2 class="h4 mt-2">
						{post.title}
					</h2>

					<div class="mb-0">
						<div id="gradient" class="w-100 h-75" />
						{post.content[0].text}
					</div>
				</a>
			</div>
		</div>
	{/each}
</div>

<style lang="sass">
	@media only screen and (min-width: 576px)
		.container
			width: 50rem

	.sidebar
		z-index: 1
		// min-width: 3rem

	// #replycount
	// 	justify-content: center

	.post
		height: 10rem
		overflow: hidden
		word-break: break-word

		border-color: var(--accent2)
		transition: all 0.3s ease-out
		&:hover
			background: var(--background)
			border-color: var(--accent3)

	#gradient
		position: absolute
		bottom: 0
		left: 0
		height: 5rem !important
		background: linear-gradient(#0000, var(--darker))

	.user
		align-items: center 
		.pfp img
			max-width: 2rem
			width: 2rem
</style>
