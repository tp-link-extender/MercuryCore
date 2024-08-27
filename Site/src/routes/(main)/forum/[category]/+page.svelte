<script lang="ts">
	import { page } from "$app/stores"
	import Breadcrumbs from "$components/Breadcrumbs.svelte"
	import Head from "$components/Head.svelte"
	import Pagination from "$components/Pagination.svelte"
	import ForumPost from "./ForumPost.svelte"

	export let data
</script>

<Head name={data.siteName} title="{data.name} - Forum" />

<div class="ctnr max-w-200">
	<Breadcrumbs
		path={[
			["Forum", "/forum"],
			[data.name, ""]
		]} />

	<h1 class="pb-8">
		{data.name} &ndash; Forum
		<span class="pl-6">
			<a
				href="/forum/create?category={data.name}"
				class="btn btn-primary">
				<fa fa-file class="pr-2" />
				Create post
			</a>
		</span>
	</h1>
	{#if data.posts.length > 0}
		<div class="flex flex-col gap-4">
			{#each data.posts as post, num (post.id)}
				<ForumPost
					{post}
					{num}
					total={data.posts.length}
					categoryName={data.name} />
			{/each}
		</div>
		{#key $page.url}
			<Pagination totalPages={data.pages} />
		{/key}
	{:else}
		<h2 class="text-center">
			No posts in this category yet. Be the first to create one!
		</h2>
	{/if}
</div>
