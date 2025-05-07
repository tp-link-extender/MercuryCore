<script lang="ts">
	const { path, final }: { path: [string, string][]; final: string } =
		$props()
</script>

<nav aria-label="breadcrumb">
	<ol
		class="grey-text text-base px-0 flex flex-wrap list-none items-center justify-start">
		{#each path as [name, href]}
			<li><a {href} class="accent-text">{name}</a></li>
		{/each}
		<li>{final}</li>
	</ol>
</nav>

<style>
	li:not(:last-child)::after {
		content: "/";
		padding: 0 0.6rem 0 0.4rem; /* magic */
	}
</style>
