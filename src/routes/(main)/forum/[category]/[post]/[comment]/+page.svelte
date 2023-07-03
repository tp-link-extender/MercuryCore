<script lang="ts">
	import ForumReply from "$lib/components/ForumReply.svelte"
	import { writable } from "svelte/store"

	let replyingTo = writable("")
	const repliesCollapsed = writable({})

	export let data
	const { user } = data

	$: topReply = data.replies[0]
	$: parentPost = topReply.parentPost
</script>

<svelte:head>
	<title>Replies to forum post - Mercury</title>
</svelte:head>

<div class="container light-text">
	<nav aria-label="breadcrumb" class="mx-auto">
		<ol class="breadcrumb border-0 m-0 shadow-none fs-6">
			<li class="breadcrumb-item">
				<a href="/forum" class="accent-text">Forum</a>
			</li>
			<li class="breadcrumb-item">
				<a
					href="/forum/{parentPost.forumCategoryName}"
					class="accent-text">
					{parentPost.forumCategoryName}
				</a>
			</li>
			<li class="breadcrumb-item">
				<a
					href="/forum/{parentPost.forumCategoryName}/{parentPost.id}"
					class="accent-text">
					{parentPost.title}
				</a>
			</li>
			<li class="breadcrumb-item active" aria-current="page">
				{topReply.content[0].text}
			</li>
		</ol>
	</nav>

	{#each data.replies as reply, num}
		<ForumReply
			{user}
			{reply}
			{num}
			{replyingTo}
			forumCategory={data.forumCategory}
			postId={data.postId}
			postAuthorName={data.author}
			{repliesCollapsed} />
	{/each}
</div>

<style lang="sass">
	@media only screen and (min-width: 576px)
		.container
			width: 70rem
</style>
