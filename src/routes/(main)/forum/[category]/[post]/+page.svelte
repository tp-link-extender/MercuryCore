<script lang="ts">
	import { page } from "$app/stores"
	import ForumReply from "$lib/components/ForumReply.svelte"
	import Report from "$lib/components/Report.svelte"
	import { writable } from "svelte/store"
	import { superForm } from "sveltekit-superforms/client"

	let replyingTo = writable("")
	const repliesCollapsed = writable({})

	export let data
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

	const baseDepth = writable(data.baseDepth)
</script>

<svelte:head>
	<title>{data.title} - Mercury</title>
</svelte:head>

<div class="container light-text">
	<div class="post card bg-darker flex-row">
		<form
			use:enhance
			class="sidebar bg-a me-2 p-1"
			method="POST"
			action="?/like">
			<input type="hidden" name="id" value={data.id} />
			<div class="row mb-2 d-flex">
				<div>
					<button
						name="action"
						value={data.likes ? "unlike" : "like"}
						aria-label={data.likes ? "Unlike" : "Like"}
						class="btn btn-sm {data.likes
							? 'btn-success'
							: 'btn-outline-success'}">
						{#if data.likes}
							<i class="fa fa-thumbs-up" />
						{:else}
							<i class="far fa-thumbs-up" />
						{/if}
					</button>
				</div>
				<span
					class="my-2 text-center {data.likes
						? 'text-success fw-bold'
						: data.dislikes
						? 'text-danger fw-bold'
						: ''}">
					{data.likeCount - data.dislikeCount}
				</span>
				<div>
					<button
						name="action"
						value={data.dislikes ? "undislike" : "dislike"}
						aria-label={data.dislikes ? "Undislike" : "Dislike"}
						class="btn btn-sm {data.dislikes
							? 'btn-danger'
							: 'btn-outline-danger'}">
						{#if data.dislikes}
							<i class="fa fa-thumbs-down" />
						{:else}
							<i class="far fa-thumbs-down" />
						{/if}
					</button>
				</div>
			</div>
		</form>
		<div class="p-3 text-decoration-none light-text w-100">
			<span class="d-flex">
				<a
					href="/user/{data.author.number}"
					class="user d-flex text-decoration-none">
					<span class="pfp bg-a2 rounded-circle">
						<img
							src={data.author.image}
							alt={data.author.username}
							class="rounded-circle rounded-top-0" />
					</span>
					<span class="fw-bold ms-3 light-text">
						{data.author.username}
					</span>
					<span class="ms-3 light-text">
						{data.posted.toLocaleString()}
					</span>
				</a>
				<span class="ms-auto">
					<Report
						user={data.author.username}
						url="/forum/{data.forumCategory.name}/{data.id}" />
				</span>
			</span>
			<h2 class="h4 mt-2">
				{data.title}
			</h2>
			<p>
				{data.content[0].text}
			</p>
		</div>
	</div>

	<form use:enhance class="mt-2 mb-4 p-1 row" method="POST" action="?/reply">
		<label for="content" class="form-label light-text mt-2">
			Post a Reply
		</label>
		<fieldset class="col-lg-7 d-flex">
			<textarea
				bind:value={$form.content}
				{...$constraints.content}
				class="form-control {$errors.content ? 'is-in' : ''}valid"
				name="content"
				placeholder="What are your thoughts?"
				rows="4" />
			<button type="submit" class="btn btn-success ms-3 mt-auto">
				{#if $delayed}
					Working...
				{:else}
					Reply
				{/if}
			</button>
		</fieldset>
		<p
			class="mb-3"
			class:text-success={$page.status == 200}
			class:text-danger={$page.status >= 400 || $errors.status}>
			{$errors.status || $message || ""}
		</p>
	</form>

	{#each data.replies as reply, num}
		<ForumReply
			{reply}
			{num}
			{replyingTo}
			forumCategory={data.forumCategory.name}
			postId={data.id}
			postAuthorName={data.author.username}
			{repliesCollapsed}
			{baseDepth}
			topLevel />
	{/each}
</div>

<style lang="sass">
	@media only screen and (min-width: 576px)
		.container
			width: 70rem

	.sidebar
		width: 2.5rem

	.post
		border-color: var(--accent2)

	p
		word-break: break-word

	.user
		align-items: center 
		.pfp img
			max-width: 2rem
			width: 2rem
</style>
