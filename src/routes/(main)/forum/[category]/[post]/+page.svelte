<script lang="ts">
	import { page } from "$app/stores"
	import { enhance as enhance2 } from "$app/forms"
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
	<nav aria-label="breadcrumb">
		<ol class="breadcrumb border-0 m-0 p-0 text-base">
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
			<div class="grid grid-cols-12 gap-6 mb-2 flex">
				<div>
					<button
						name="action"
						value={data.likes ? "unlike" : "like"}
						aria-label={data.likes ? "Unlike" : "Like"}
						class="btn btn-sm {data.likes
							? 'bg-emerald-600 hover:bg-emerald-800 text-white'
							: 'btn-outline-success'}">
						<i class="fa{data.likes ? '' : 'r'} fa-thumbs-up" />
					</button>
				</div>
				<span
					class="my-2 text-center {data.likes
						? 'text-emerald-500 font-bold'
						: data.dislikes
						? 'text-red-500 font-bold'
						: ''}">
					{data.likeCount - data.dislikeCount}
				</span>
				<div>
					<button
						name="action"
						value={data.dislikes ? "undislike" : "dislike"}
						aria-label={data.dislikes ? "Undislike" : "Dislike"}
						class="btn btn-sm {data.dislikes
							? 'bg-red-500'
							: 'btn-outline-danger'}">
						<i
							class="fa{data.dislikes
								? ''
								: 'r'} fa-thumbs-down" />
					</button>
				</div>
			</div>
		</form>
		<div class="p-3 no-underline light-text w-100">
			<span class="flex">
				<a
					href="/user/{data.author.number}"
					class="user flex no-underline light-text">
					<span class="pfp bg-a2 rounded-full">
						<img
							src="/api/avatar/{data.author.username}"
							alt={data.author.username}
							class="rounded-full rounded-top-0" />
					</span>
					<span class="font-bold ms-3">
						{data.author.username}
					</span>
					<span class="ms-3">
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
		<fieldset class="lg:col-span-7 flex">
			<textarea
				bind:value={$form.content}
				{...$constraints.content}
				class="form-control {$errors.content ? 'is-in' : ''}valid"
				name="content"
				placeholder="What are your thoughts?"
				rows="4" />
			<button
				type="submit"
				class="btn bg-emerald-600 hover:bg-emerald-800 text-white ms-3 mt-auto">
				{#if $delayed}
					Working...
				{:else}
					Reply
				{/if}
			</button>
		</fieldset>
		<p
			class="mb-3"
			class:text-emerald-500={$page.status == 200}
			class:text-red-500={$page.status >= 400 || $errors.status}>
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
