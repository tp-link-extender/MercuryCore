<script lang="ts">
	import fade from "$lib/fade"

	export let data
</script>

<svelte:head>
	<title>Forum - Mercury</title>
</svelte:head>

<div class="container light-text">
	<h1 class="light-text mb-5">Forum</h1>
	{#each data.categories as category, num}
		<div
			in:fade={{ num, total: data.categories.length }}
			class="category card bg-darker p-3 mb-3">
			<div class="grid grid-cols-12 gap-6">
				<a
					class="lg:col-span-9 md:col-span-7 row light-text no-underline"
					href="/forum/{category.name.toLowerCase()}">
					<div class="col-span-9">
						<h2 class="h4">
							{category.name}
						</h2>
						{category.description}
					</div>
					<h3 class="col h5">
						{category._count.posts} post{category._count.posts > 1
							? "s"
							: ""}
					</h3>
				</a>
				<div class="lg:col-span-3 md:col-span-5 row">
					{#if category.posts[0]}
						<a
							href="/forum/{category.name.toLowerCase()}/{category
								.posts[0].id}"
							class="light-text no-underline">
							Last post:
							<h3 class="h5">
								{category.posts[0].title}
							</h3>
						</a>
						<span class="flex">
							by
							<a
								href="/user/{category.posts[0].author.number}"
								class="light-text no-underline flex">
								<span class="pfp bg-a2 rounded-full mx-1">
									<img
										src="/api/avatar/{category.posts[0]
											.author.username}"
										alt={category.posts[0].author.username}
										class="rounded-full rounded-top-0" />
								</span>
								{category.posts[0].author.username}
							</a>
						</span>
					{/if}
				</div>
			</div>
		</div>
	{/each}
</div>

<style lang="sass">
	@media only screen and (min-width: 576px)
		.container
			width: 70rem

	.category
		border-color: var(--accent2)
		transition: all 0.3s ease-out

	.pfp, .pfp img
		width: 1.5rem
		height: 1.5rem
</style>
