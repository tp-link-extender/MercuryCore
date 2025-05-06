<script lang="ts">
	import { invalidateAll } from "$app/navigation"
	import Breadcrumbs from "$components/Breadcrumbs.svelte"
	import ForumReply from "$components/ForumReply.svelte"
	import Head from "$components/Head.svelte"

	let replyingTo = $state("")
	let repliesCollapsed = $state({})
	let refresh = $state(0)

	let { data } = $props()
	let replies = $state(data.replies)
	$effect(() => {
		replies = data.replies
	})

	let topReply = $derived(replies[0])
	let parentPost = $derived(topReply.parentPost)
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
		{#each replies as reply, num}
			<ForumReply
				user={data.user}
				bind:reply={replies[num]}
				{num}
				bind:replyingTo
				categoryName={data.forumCategory}
				postId={data.postId}
				postAuthorName={data.author}
				bind:repliesCollapsed
				pinnable={!reply.parentReplyId}
				refreshReplies={() =>
					async ({ result }) => {
						if (result.type === "success") await invalidateAll()
						refresh++
					}} />
		{/each}
	{/key}
</div>
