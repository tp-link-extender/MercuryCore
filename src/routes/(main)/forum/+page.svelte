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
		<a
			in:fade={{ num, total: data.categories.length }}
			href="/forum/{category.name.toLowerCase()}"
			class="category card text-decoration-none light-text p-3 mb-3">
			<div class="row">
				<div class="col col-6">
					<h2 class="h4 col col-md-3">
						{category.name}
					</h2>
					{category.description}
				</div>
				<div class="col col-6 row">
					<div class="col col-6">
						<h3 class="h5">
							{category._count.posts} post{category._count.posts >
							1
								? "s"
								: ""}
						</h3>
					</div>
					{#if category.posts[0]}
					<div class="col col-6">
						Last post:
						<br />
						<a
							href="/forum/{category.name.toLowerCase()}/{category
								.posts[0].id}"
							class="h5 text-decoration-none">
							{category.posts[0].title}
						</a>
						<br />
						by
						<a
							href="/user/{category.posts[0].author.number}"
							class="light-text">
							{category.posts[0].author.username}
						</a>
					</div>
					{/if}
				</div>
			</div>
		</a>
	{/each}
</div>

<style lang="sass">
	@media only screen and (min-width: 576px)
		.container
			width: 70rem

	.category
		background: var(--darker)
		border-color: var(--accent2)
		transition: all 0.3s ease-out
		&:hover
			background: var(--accent)
			border-color: var(--accent3)
</style>
