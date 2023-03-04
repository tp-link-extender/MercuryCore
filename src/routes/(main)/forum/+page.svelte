<script lang="ts">
	import type { PageData } from "./$types"
	import fade from "$lib/fade"

	export let data: PageData
	//
</script>

<svelte:head>
	<title>Forum - Mercury</title>
</svelte:head>

<h1 class="text-center light-text">Forum</h1>

<div class="container mt-5 light-text h5">
	{#each data.categories as category, num}
		<a in:fade={{ num, total: data.categories.length }} href="/forum/{category.name}" class="category card text-decoration-none light-text p-3 mb-3">
			<div class="row mb-3">
				<h2 class="h4 col col-md-3">
					{category.name}
				</h2>
				<p class="fs-6 col">
					{category.description}
				</p>
			</div>
		</a>
	{/each}
</div>

<style lang="sass">
	@media only screen and (min-width: 576px)
		.container
			width: 50rem

	.category
		background: var(--darker)
		border-color: var(--accent2)
		transition: all 0.3s ease-out
		&:hover
			background: var(--accent)
			border-color: var(--accent3)
</style>
