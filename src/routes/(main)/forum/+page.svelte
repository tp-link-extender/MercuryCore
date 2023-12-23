<script lang="ts">
	export let data
</script>

<Head title="Forum" />

<div class="container light-text flex flex-column gap-4">
	<h1 class="pb-6">Forum</h1>
	{#each data.categories as category, num}
		<div
			in:fade|global={{ num, total: data.categories.length }}
			class="category card bg-darker p-4">
			<div class="row">
				<a
					class="col-lg-9 col-md-7 row light-text text-decoration-none"
					href="/forum/{category.name.toLowerCase()}">
					<div class="col-9">
						<h2>
							{category.name}
						</h2>
						{category.description}
					</div>
					<h3 class="col">
						{category.postCount} post{category.postCount == 1
							? ""
							: "s"}
					</h3>
				</a>
				<div class="col-lg-3 col-md-5 row">
					{#if category.latestPost}
						<a
							href="/forum/{category.name.toLowerCase()}/{category
								.latestPost.id}"
							class="light-text text-decoration-none">
							Last post:
							<h3>
								{category.latestPost.title}
							</h3>
						</a>
						<span class="d-flex gap-2">
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
</div>

<style lang="stylus">
	containerMinWidth(70rem)

	.container
		flex-direction column !important

	.category
		border 1px solid var(--accent2)
		transition all 0.3s ease-out
</style>
