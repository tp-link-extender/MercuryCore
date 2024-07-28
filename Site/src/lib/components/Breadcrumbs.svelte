<script lang="ts">
	export let path: [string, string][]
</script>

<nav aria-label="breadcrumb">
	<ol
		class="grey-text text-base px-0 flex flex-wrap list-none items-center justify-start">
		{#each path as [name, href], num}
			<li>
				{#if num === path.length - 1}
					{name}
				{:else}
					<a {href} class="accent-text">{name}</a>
				{/if}
			</li>
		{/each}
	</ol>
</nav>

<style>
	li:not(:last-child)::after {
		content: "/";
		padding: 0 0.6rem 0 0.4rem; /* magic */
	}
</style>
