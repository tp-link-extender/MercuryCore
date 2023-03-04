<script lang="ts">
	import type { PageData } from "./$types"
	import { enhance } from "$app/forms"
	import fade from "$lib/fade"

	export let data: PageData
	// Forum
	// data.posts contain each post as {id, content, likes, dislikes, author: {username}}
</script>

<svelte:head>
	<title>{data.name} forum - Mercury</title>
</svelte:head>

<h1 class="text-center light-text">{data.name} - Forum</h1>

<div class="container mt-5 light-text">
	{#each data.posts as post, num}
		<div in:fade|global={{ num, total: data.posts.length }} class="card mb-3 flex-row">
			<form use:enhance class="sidebar me-2 p-1" method="POST" action="?/like">
				<input type="hidden" name="id" value={post.id} />
				<div class="row mb-2 d-flex">
					<div>
						<button name="action" value={post.likes ? "unlike" : "like"} class="btn btn-sm {post.likes ? 'btn-success' : 'btn-outline-success'}">
							{#if post.likes}
								<i class="fa fa-thumbs-up" />
							{:else}
								<i class="fa-regular fa-thumbs-up" />
							{/if}
						</button>
					</div>
					<span class="my-2 text-center">
						{post.likeCount - post.dislikeCount}
					</span>
					<div>
						<button name="action" value={post.dislikes ? "undislike" : "dislike"} class="btn btn-sm {post.dislikes ? 'btn-danger' : 'btn-outline-danger'}">
							{#if post.dislikes}
								<i class="fa fa-thumbs-down" />
							{:else}
								<i class="fa-regular fa-thumbs-down" />
							{/if}
						</button>
					</div>
				</div>
			</form>
			<a href="/forum/{data.name}/{post.id}" class="p-3 text-decoration-none light-text">
				<div>
					<a href="/user/{post.author.number}" class="user d-flex text-decoration-none">
						<span class="pfp rounded-circle">
							<img src={post.author.image} alt={post.author.username} class="rounded-circle rounded-top-0" />
						</span>
						<span class="fw-bold ms-3 light-text">{post.author.username}</span>
						<span class="light-text ms-auto">{post.posted.toLocaleString()}</span>
					</a>
					<h2 class="h4 mt-2">
						{post.title}
					</h2>
				</div>
				<p>
					{post.content}
				</p>
			</a>
		</div>
	{/each}
</div>

<style lang="sass">
	@media only screen and (min-width: 576px)
		.container
			width: 50rem

	.sidebar
		background: var(--accent)

	.card
		background: var(--darker)
		border-color: var(--accent2)
		transition: all 0.3s ease-out
		&:hover
			background: var(--background)
			border-color: var(--accent3)

	.user
		align-items: center 
		.pfp
			background: var(--accent2)
			img
				max-width: 2rem
				width: 2rem
</style>
