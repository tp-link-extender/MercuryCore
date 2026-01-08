<script lang="ts">
	import { page } from "$app/state"
	import Breadcrumbs from "$components/Breadcrumbs.svelte"
	import Head from "$components/Head.svelte"
	import Pagination from "$components/Pagination.svelte"
	import { likeFns } from "$lib/like2"
	import { likeForm } from "../../like.remote"
	import { getCategory } from "./category.remote"
	import ForumPost from "./ForumPost.svelte"

	const { data } = $props()
	const category = getCategory()
</script>

<!-- no, there is unfortunately no alternative -->
{#if true}
	{@const { name, posts, pages } = await category}
	<Head name={data.siteName} title="{name} - Forum" />

	<div class="ctnr max-w-200">
		<Breadcrumbs path={[["Forum", "/forum"]]} final={name} />

		<h1 class="pb-8">
			{name} &ndash; Forum
			<span class="pl-6">
				<a href="/forum/create?category={name}" class="btn btn-primary">
					<fa fa-file class="pr-2"></fa>
					Create post
				</a>
			</span>
		</h1>
		{#if posts.length > 0}
			<div class="flex flex-col gap-4">
				{#each posts as post, num (post.id)}
					<!-- Make sure to put this in an @const here, and separate it from the .enhance() call in the component property, or else ALL HELL WILL BREAK LOOSE -->
					{@const likePost = likeForm.for(post.id)}

					<ForumPost
						likeForm={likePost.enhance(o =>
							o.submit().updates(
								category.withOverride(c => {
									likeFns[o.data.action](c.posts[num])
									return c
								})
							)
						)}
						{num}
						{post}
						total={posts.length} />
				{/each}
			</div>
			{#key page.url}
				<Pagination totalPages={pages} />
			{/key}
		{:else}
			<h2 class="text-center">No posts in this category yet.</h2>
			<h3 class="pt-4 text-center">Be the first to write one!</h3>
		{/if}
	</div>
{/if}
