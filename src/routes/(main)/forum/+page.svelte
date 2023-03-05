<script lang="ts">
	import type { PageData } from "./$types"
	import fade from "$lib/fade"

	export let data: PageData
	//
</script>

<svelte:head>
	<title>Forum - Mercury</title>
</svelte:head>

<div class="container light-text">
	<h1 class="light-text mb-5">Forum</h1>
	{#each data.categories as category, num}
		<a in:fade={{ num, total: data.categories.length }} href="/forum/{category.name}" class="category card text-decoration-none light-text p-3 mb-3">
			<div class="">
				<h2 class="h4 col col-md-3">
					{category.name}
				</h2>
				<p>
					{category.description}
				</p>
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
