<script lang="ts">
	let replyingTo = writable("")
	const repliesCollapsed = writable({})

	export let data
	const { user } = data

	$: topReply = data.replies[0]
	$: parentPost = topReply.parentPost
</script>

<Head title="Replies to forum post" />

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
			categoryName={data.forumCategory}
			postId={data.postId}
			postAuthorName={data.author}
			{repliesCollapsed} />
	{/each}
</div>

<style lang="stylus">
	containerMinWidth(70rem)
</style>
