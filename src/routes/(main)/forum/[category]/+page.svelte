<script lang="ts">
	import ForumPost from "./ForumPost.svelte"

	export let data
	// Forum
	// data.posts contain each post as {id, content, likes, dislikes, author: {username}}
</script>

<Head title="{data.name} - Forum" />

<div class="container light-text">
	<Breadcrumbs
		path={[
			["Forum", "/forum"],
			[data.name, ""],
		]} />

	<h1 class="light-text pb-8">
		{data.name} - Forum
		<span class="ps-6">
			<a
				href="/forum/create?category={data.name}"
				class="btn btn-primary ">
				<i class="fa fa-file pe-2" />
				Create post
			</a>
		</span>
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
