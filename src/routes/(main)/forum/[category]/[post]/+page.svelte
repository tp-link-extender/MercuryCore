<script lang="ts">
	import type { PageData } from "./$types"
	import { enhance } from "$app/forms"
	import ForumReply from "$lib/components/ForumReply.svelte"
	import { writable } from "svelte/store"

	let replyingTo = writable("")
	const repliesCollapsed = writable({})

	export let data: PageData
	const baseDepth = writable(data.baseDepth)
</script>

<svelte:head>
	<title>{data.title} - Mercury</title>
</svelte:head>

<div class="container light-text">
	<div class="card post flex-row">
		<form use:enhance class="sidebar me-2 p-1" method="POST" action="/forum/{data.forumCategory.name}?/like">
			<input type="hidden" name="id" value={data.id} />
			<div class="row mb-2 d-flex">
				<div>
					<button name="action" value={data.likes ? "unlike" : "like"} class="btn btn-sm {data.likes ? 'btn-success' : 'btn-outline-success'}">
						{#if data.likes}
							<i class="fa fa-thumbs-up" />
						{:else}
							<i class="fa-regular fa-thumbs-up" />
						{/if}
					</button>
				</div>
				<span class="my-2 text-center {data.likes ? 'text-success fw-bold' : data.dislikes ? 'text-danger fw-bold' : ''}">
					{data.likeCount - data.dislikeCount}
				</span>
				<div>
					<button name="action" value={data.dislikes ? "undislike" : "dislike"} class="btn btn-sm {data.dislikes ? 'btn-danger' : 'btn-outline-danger'}">
						{#if data.dislikes}
							<i class="fa fa-thumbs-down" />
						{:else}
							<i class="fa-regular fa-thumbs-down" />
						{/if}
					</button>
				</div>
			</div>
		</form>
		<div class="p-3 text-decoration-none light-text w-100">
			<a href="/user/{data.author.number}" class="user d-flex text-decoration-none">
				<span class="pfp rounded-circle">
					<img src={data.author.image} alt={data.author.username} class="rounded-circle rounded-top-0" />
				</span>
				<span class="fw-bold ms-3 light-text">{data.author.username}</span>
				<span class="light-text ms-auto">{data.posted.toLocaleString()}</span>
			</a>
			<h2 class="h4 mt-2">
				{data.title}
			</h2>
			<p>
				{data.content}
			</p>
		</div>
	</div>

	<form use:enhance class="mt-2 mb-4 p-1 row" method="POST" action="?/reply">
		<label for="content" class="form-label light-text mt-2">Post a Reply</label>
		<fieldset class="col-lg-7 d-flex">
			<textarea class="form-control valid" required minlength="15" maxlength="1000" name="content" placeholder="What are your thoughts?" rows="4" />
			<button type="submit" class="btn btn-success h-100 ms-3">Reply</button>
		</fieldset>
	</form>

	{#each data.replies as reply, num}
		<ForumReply {reply} {num} {replyingTo} forumCategory={data.forumCategory.name} postId={data.id} postAuthorName={data.author.username} {repliesCollapsed} {baseDepth} topLevel />
	{/each}
</div>

<style lang="sass">
	@media only screen and (min-width: 576px)
		.container
			width: 70rem

	.sidebar
		background: var(--accent)
		width: 2.5rem

	.post
		background: var(--darker)
		border-color: var(--accent2)

	p
		word-break: break-word
		
	.user
		align-items: center 
		.pfp
			background: var(--accent2)
			img
				max-width: 2rem
				width: 2rem
</style>
