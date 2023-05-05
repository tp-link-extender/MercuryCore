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
			<div class="row">
				<a
					class="col-lg-9 col-md-7 row light-text text-decoration-none"
					href="/forum/{category.name.toLowerCase()}">
					<div class="col-9">
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
				<div class="col-lg-3 col-md-5 row">
					{#if category.posts[0]}
						<div class="col-6">
							<a
								href="/forum/{category.name.toLowerCase()}/{category
									.posts[0].id}"
								class="light-text text-decoration-none">
								Last post:
								<h3 class="h5">
									{category.posts[0].title}
								</h3>
							</a>
							<span class="d-flex">
								by
								<a
									href="/user/{category.posts[0].author
										.number}"
									class="light-text text-decoration-none d-flex">
									<span class="pfp bg-a2 rounded-circle mx-1">
										<img
											src={category.posts[0].author.image}
											alt={category.posts[0].author
												.username}
											class="rounded-circle rounded-top-0" />
									</span>
									{category.posts[0].author.username}
								</a>
							</span>
						</div>
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
