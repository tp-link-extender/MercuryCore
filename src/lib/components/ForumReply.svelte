<script lang="ts">
	import { enhance } from "$app/forms"
	import fade from "$lib/fade"
	import type { Writable } from "svelte/store"

	// too many exports help
	export let reply: any
	export let num: number
	export let baseDepth: Writable<number>
	export let depth: number = $baseDepth
	export let replyingTo: Writable<string>
	export let forumCategory: string
	export let postId: string
	export let repliesCollapsed: Writable<any>
	export let topLevel = false
	// Some have to be writables to allow them to keep state,
	// either on element destroy or on page change

	let content = "" // Allows current reply to not be lost on clicking to another reply

	const collapse = (id: string) => () => {
		console.log(2)
		repliesCollapsed.update(collapsed => {
			collapsed[id] = !collapsed[id]
			return collapsed
		})
	}
</script>

{#if reply && reply.author}
	{#if depth == $baseDepth && !topLevel}
		<a href="/forum/{forumCategory}/{postId}" class="text-decoration-none"><i class="fa fa-arrow-left me-2" />Parent post</a>
		{#if reply.parentReplyId}
			<br />
			<a href="/forum/{forumCategory}/{postId}/{reply.parentReplyId}?depth={depth - 1}" class="text-decoration-none"><i class="fa fa-arrow-up me-2" />Parent reply</a>
		{/if}
	{/if}
	<div in:fade|global={{ num }} class="d-flex mt-2">
		<form use:enhance class="me-2 p-1 pt-2 ps-0 sidebar2 d-flex h-100" method="POST" action="/forum/{forumCategory}?/like">
			<input type="hidden" name="replyId" value={reply.id} />
			<div class="row mb-2">
				<div>
					<button name="action" value={reply.likes ? "unlike" : "like"} class="smallbutton p-0 btn btn-sm">
						{#if reply.likes}
							<i class="fa fa-thumbs-up text-success" />
						{:else}
							<i class="fa-regular fa-thumbs-up" />
						{/if}
					</button>
				</div>
				<span class="my-1 text-center {reply.likes ? 'text-success fw-bold' : reply.dislikes ? 'text-danger fw-bold' : ''}">
					{reply.likeCount - reply.dislikeCount}
				</span>
				<div>
					<button name="action" value={reply.dislikes ? "undislike" : "dislike"} class="smallbutton p-0 btn btn-sm">
						{#if reply.dislikes}
							<i class="fa fa-thumbs-down text-danger" />
						{:else}
							<i class="fa-regular fa-thumbs-down" />
						{/if}
					</button>
				</div>
			</div>
		</form>

		<div class="w-100">
			<a href="/user/{reply.author.number}" class="user d-flex text-decoration-none pt-2">
				<span class="pfp rounded-circle">
					<img src={reply.author.image} alt={reply.author.username} class="rounded-circle rounded-top-0" />
				</span>
				<span class="fw-bold ms-3 light-text">{reply.author.username}</span>
				<small class="light-text ps-4">{reply.posted.toLocaleString()}</small>
			</a>
			<p class="my-2">
				{reply.content}
			</p>
			{#if $replyingTo != reply.id}
				<button on:click={() => replyingTo.set(reply.id)} class="p-0 btn btn-sm grey-text px-1">
					<i class="fa-regular fa-message pe-2" /> Reply
				</button>
			{/if}
			{#if $replyingTo == reply.id}
				<div class="mb-2 card reply">
					<div class="card-body p-3 pt-1 pb-0">
						<form use:enhance class="mb-4" method="POST" action="/forum/{forumCategory}/{reply.id}?/reply">
							<input type="hidden" name="replyId" value={reply.id} />
							<label for="content" class="form-label light-text mt-2">Post a Reply</label>
							<fieldset>
								<textarea bind:value={content} class="form-control valid mb-2" required name="content" placeholder="What are your thoughts?" rows="4" />
								<button type="submit" class="btn btn-success">
									<i class="fa-regular fa-message me-2" />Reply
								</button>
								<button on:click={() => replyingTo.set("")} class="btn btn-dark grey-text ms-1">
									<i class="fa fa-cancel me-2" />Cancel
								</button>
							</fieldset>
						</form>
					</div>
				</div>
			{/if}
		</div>
	</div>

	{#if depth > $baseDepth + 8}
		<a href="/forum/{forumCategory}/{postId}/{reply.id}?depth={depth}" class="text-decoration-none"><i class="fa fa-arrow-down me-2" />More replies</a>
	{/if}

	{#each reply.replies as reply2}
		<div class="d-flex">
			<button on:click={collapse(reply2.id)} id="collapse" class="mx-2 p-0 border-0" />
			{#if $repliesCollapsed?.[reply2.id]}
				<button on:click={collapse(reply2.id)} id="collapse2" class="m-2"> Expand replies </button>
			{:else}
				<div>
					<!-- Get READY for some RECURSION!!! -->
					<svelte:self reply={reply2} {num} {replyingTo} {forumCategory} {postId} {repliesCollapsed} depth={depth + 1} {baseDepth} />
				</div>
			{/if}
		</div>
	{/each}
{/if}

<style lang="sass">
	.sidebar2
		width: 2rem

	#collapse, #collapse2
		transition: all 0.2s ease-out
	
	#collapse
		width: 14px
		background: var(--accent2)
		border-left: 3px solid var(--background) !important
		border-right: 9px solid var(--background) !important
		&:hover
			background: var(--grey-text)

	#collapse2
		border: none
		background: none
		color: var(--accent3)
		&:hover
			color: var(--grey-text)

	.reply
		background: var(--background)
		border-color: var(--accent2)

	.smallbutton
		width: 1.5rem
		height: 1.5rem

	.reply
		background: var(--background)
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
