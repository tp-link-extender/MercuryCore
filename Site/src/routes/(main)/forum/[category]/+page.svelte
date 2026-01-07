<script lang="ts">
	import { page } from "$app/state"
	import Breadcrumbs from "$components/Breadcrumbs.svelte"
	import Head from "$components/Head.svelte"
	import Pagination from "$components/Pagination.svelte"
	import ForumPost from "./ForumPost.svelte"

	const { data } = $props()

	const posts = $state((() => data.posts)())
</script>

<Head name={data.siteName} title="{data.name} - Forum" />

<div class="ctnr max-w-200">
	<Breadcrumbs path={[["Forum", "/forum"]]} final={data.name} />

	<h1 class="pb-8">
		{data.name} &ndash; Forum
		<span class="pl-6">
			<a
				href="/forum/create?category={data.name}"
				class="btn btn-primary">
				<fa fa-file class="pr-2"></fa>
				Create post
			</a>
		</span>
	</h1>
	{#if posts.length > 0}
		<div class="flex flex-col gap-4">
			{#each posts as post, num (post.id)}
				<ForumPost bind:post={posts[num]} {num} total={posts.length} />
			{/each}
		</div>
		{#key page.url}
			<Pagination totalPages={data.pages} />
		{/key}
	{:else}
		<h2 class="text-center">No posts in this category yet.</h2>
		<h3 class="pt-4 text-center">Be the first to write one!</h3>
	{/if}
</div>
