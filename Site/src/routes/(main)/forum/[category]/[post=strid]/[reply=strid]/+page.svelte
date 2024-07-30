<script lang="ts">
	import { invalidateAll } from "$app/navigation"
	import Breadcrumbs from "$components/Breadcrumbs.svelte"
	import ForumReply from "$components/ForumReply.svelte"
	import Head from "$components/Head.svelte"
	import { writable } from "svelte/store"

	let replyingTo = writable("")
	const repliesCollapsed = writable({})

	export let data

	$: topReply = data.replies[0]
	$: parentPost = topReply.parentPost

	let refresh = 0
</script>

<Head name={data.siteName} title="Replies to forum post" />

<div class="ctnr max-w-280">
	<Breadcrumbs
		path={[
			["Forum", "/forum"],
			[
				parentPost.forumCategoryName,
				`/forum/${parentPost.forumCategoryName}`
			],
			[
				parentPost.title,
				`/forum/${parentPost.forumCategoryName}/${parentPost.id}`
			],
			[topReply.content[0].text, ""]
		]} />

	{#key refresh}
		{#each data.replies as reply, num}
			<ForumReply
				user={data.user}
				{reply}
				{num}
				{replyingTo}
				categoryName={data.forumCategory}
				postId={data.postId}
				postAuthorName={data.author}
				{repliesCollapsed}
				pinnable={!reply.parentReplyId}
				refreshReplies={() =>
					async ({ result }) => {
						if (result.type === "success") await invalidateAll()
						refresh++
					}} />
		{/each}
	{/key}
</div>
