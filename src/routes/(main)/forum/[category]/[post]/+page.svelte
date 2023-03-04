<script lang="ts">
	import type { PageData } from "./$types"
	import { enhance } from "$app/forms"
	import fade from "$lib/fade"

	export let data: PageData
	//
</script>

<svelte:head>
	<title>{data.title} - Mercury</title>
</svelte:head>

<div class="container light-text">
	<div class="card flex-row">
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
				<span class="my-2 text-center">
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
		<div class="p-3 text-decoration-none light-text">
			<div>
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
			</div>
			<p>
				{data.content}
			</p>
		</div>
	</div>

	<form use:enhance class="mt-2 mb-4 p-1 row" method="POST" action="?/reply">
		<label for="bio" class="form-label light-text mt-2">Post a Reply</label>
		<fieldset class="col-lg-7 d-flex">
			<textarea class="form-control valid" name="content" placeholder="What are your thoughts?" rows="4" />
			<button type="submit" class="btn btn-success h-100 ms-3">Reply</button>
		</fieldset>
	</form>

	{#each data.replies as reply, num}
		<div in:fade|global={{ num, total: data.replies.length }} class="px-3">
			<a href="/user/{reply.author.number}" class="user d-flex text-decoration-none col-lg-7">
				<span class="pfp rounded-circle">
					<img src={reply.author.image} alt={reply.author.username} class="rounded-circle rounded-top-0" />
				</span>
				<span class="fw-bold ms-3 light-text">{reply.author.username}</span>
				<span class="light-text ms-auto">{reply.posted.toLocaleString()}</span>
			</a>
			<p>
				{reply.content}
			</p>
		</div>
	{/each}
</div>

<style lang="sass">
	@media only screen and (min-width: 576px)
		.container
			width: 70rem

	.sidebar
		background: var(--accent)

	.card
		background: var(--darker)
		border-color: var(--accent2)
	.user
		align-items: center 
		.pfp
			background: var(--accent2)
			img
				max-width: 2rem
				width: 2rem
</style>
