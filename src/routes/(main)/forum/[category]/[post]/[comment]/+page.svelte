<script lang="ts">
	let replyingTo = writable("")
	const repliesCollapsed = writable({})

	export let data
	const { user } = data

	$: topReply = data.replies[0]
	$: parentPost = topReply.parentPost
</script>

<Head title="Replies to forum post" />

<div class="ctnr light-text">
	<Breadcrumbs
		path={[
			["Forum", "/forum"],
			[
				parentPost.forumCategoryName,
				`/forum/${parentPost.forumCategoryName}`,
			],
			[
				parentPost.title,
				`/forum/${parentPost.forumCategoryName}/${parentPost.id}`,
			],
			[topReply.content[0].text, ""],
		]} />

	{#each data.replies as reply, num}
		<ForumReply
			{user}
			{reply}
			{num}
			{replyingTo}
			categoryName={data.forumCategory}
			postId={data.postId}
			postAuthorName={data.author}
			{repliesCollapsed} />
	{/each}
</div>

<style lang="stylus">
	containerMinWidth(70rem)
</style>
