<script lang="ts">
	import { page } from "$app/stores"
	import { enhance as enhance2 } from "$app/forms"
	import { superForm } from "sveltekit-superforms/client"

	export let data

	let replyingTo = writable("")
	const repliesCollapsed = writable({}),
		{ user } = data,
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

<Head title={data.title} />

<div class="container light-text">
	<nav aria-label="breadcrumb">
		<ol class="breadcrumb border-0 m-0 shadow-none fs-6">
			<li class="breadcrumb-item">
				<a href="/forum" class="accent-text">Forum</a>
			</li>
			<li class="breadcrumb-item">
				<a href="/forum/{data.forumCategory.name}" class="accent-text">
					{data.forumCategory.name}
				</a>
			</li>
			<li class="breadcrumb-item active" aria-current="page">
				{data.title}
			</li>
		</ol>
	</nav>

	<div class="post card bg-darker flex-row">
		<form
			use:enhance2={e => {
				const action = e.data.get("action")

				if (action == "like") {
					data.likes = true

					if (data.dislikes) data.dislikeCount--
					data.dislikes = false
					data.likeCount++
				} else if (action == "dislike") {
					data.dislikes = true

					if (data.likes) data.likeCount--
					data.likes = false
					data.dislikeCount++
				} else if (action == "unlike") {
					data.likes = false
					data.likeCount--
				} else if (action == "undislike") {
					data.dislikes = false
					data.dislikeCount--
				}

				return () => {}
			}}
			class="sidebar bg-a me-2 p-1"
			method="POST"
			action="?/like&id={data.id}">
			<div class="row mb-2 d-flex">
				<div>
					<button
						name="action"
						value={data.likes ? "unlike" : "like"}
						aria-label={data.likes ? "Unlike" : "Like"}
						class="btn btn-sm {data.likes
							? 'btn-success'
							: 'btn-outline-success'}">
						<i class="fa{data.likes ? '' : 'r'} fa-thumbs-up" />
					</button>
				</div>
				<span
					class="my-2 text-center {data.likes
						? 'text-success font-bold'
						: data.dislikes
						? 'text-danger font-bold'
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
						<i
							class="fa{data.dislikes
								? ''
								: 'r'} fa-thumbs-down" />
					</button>
				</div>
			</div>
		</form>
		<div class="p-4 text-decoration-none light-text w-100">
			<span class="d-flex">
				<User user={data.author} full />
				<em class="ps-4 align-self-center">
					{data.posted.toLocaleString()}
				</em>
				<span class="ms-auto">
					<ReportButton
						user={data.author.username}
						url="/forum/{data.forumCategory.name}/{data.id}" />
				</span>
			</span>
			<h2 class="fs-4 mt-2">
				{data.title}
			</h2>
			<p>
				{data.content[0].text}
			</p>
		</div>
	</div>

	<form use:enhance class="mt-2 mb-6 p-1 row" method="POST" action="?/reply">
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
			<button class="btn btn-success ms-4 mt-auto">
				{#if $delayed}
					Working...
				{:else}
					Reply
				{/if}
			</button>
		</fieldset>
		<p
			class="mb-4"
			class:text-success={$page.status == 200}
			class:text-danger={$page.status >= 400}>
			{$message || ""}
		</p>
	</form>

	{#each data.replies as reply, num}
		<ForumReply
			{user}
			{reply}
			{num}
			{replyingTo}
			forumCategory={data.forumCategory.name}
			postId={data.id}
			postAuthorName={data.author.username}
			{repliesCollapsed}
			topLevel />
	{/each}
</div>

<style lang="stylus">
	containerMinWidth(70rem)

	.sidebar
		width 2.5rem

	.post
		border-color var(--accent2)

	p
		word-break break-word
</style>
