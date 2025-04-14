<script lang="ts">
	import Head from "$components/Head.svelte"
	import User from "$components/User.svelte"
	import fade from "$lib/fade"

	const { data } = $props()

	const { user } = data
</script>

<Head name={data.siteName} title="Forum" />

<div class="ctnr light-text max-w-280 flex flex-col gap-4">
	<h1 class="pb-6">Forum</h1>
	{#if data.categories.length > 0}
		{#each data.categories as category, num}
			<div
				in:fade|global={{ num, total: data.categories.length }}
				class="category card bg-darker p-4">
				<div class="flex flex-wrap">
					<a
						class="flex w-full lg:w-3/4 md:w-7/12 light-text no-underline"
						href="/forum/{category.name.toLowerCase()}">
						<div class="w-3/4">
							<h2>
								{category.name}
							</h2>
							<p>
								{category.description}
							</p>
						</div>
						<h3 class="w-1/4">
							{category.postCount || "No"} post{category.postCount ==
							1
								? ""
								: "s"}
						</h3>
					</a>
					<div class="w-full lg:w-1/4 md:w-5/12">
						{#if category.latestPost}
							<a
								href="/forum/{category.name.toLowerCase()}/{category
									.latestPost.id}"
								class="light-text no-underline">
								Latest post:
								<h3>
									{category.latestPost.title}
								</h3>
							</a>
							<span class="flex gap-2">
								by
								<User
									user={category.latestPost.author}
									full
									thin
									size="1.5rem" />
							</span>
						{/if}
					</div>
				</div>
			</div>
		{/each}
	{:else}
		<h2 class="text-center">
			There are no categories available in the forum yet.
		</h2>
		{#if user.permissionLevel === 5}
			<h3 class="text-center">
				Why not <a href="/forum/create/category">create one?</a>
			</h3>
		{/if}
	{/if}
</div>

<style>
	.category {
		border: 1px solid var(--accent2);
		transition: all 0.3s ease-out;
	}
</style>
