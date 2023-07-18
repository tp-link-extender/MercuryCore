<script lang="ts">
	export let data
	// Forum
	// data.posts contain each post as {id, content, likes, dislikes, author: {username}}
</script>

<Head title="{data.name} - Forum" />

<div class="container light-text">
	<nav aria-label="breadcrumb">
		<ol class="breadcrumb border-0 m-0 shadow-none fs-6">
			<li class="breadcrumb-item">
				<a href="/forum" class="accent-text">Forum</a>
			</li>
			<li class="breadcrumb-item active" aria-current="page">
				{data.name}
			</li>
		</ol>
	</nav>

	<h1 class="light-text mb-5">
		{data.name} - Forum
		<a
			href="/forum/create?category={data.name}"
			class="btn btn-primary ms-4">
			<i class="fa fa-file me-2" />
			Create post
		</a>
	</h1>
	{#each data.posts as post, num}
		<ForumPost
			{post}
			{num}
			total={data.posts.length}
			categoryName={data.name} />
	{/each}
</div>

<style lang="stylus">
	containerMinWidth()
</style>
