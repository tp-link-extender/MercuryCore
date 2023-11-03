<script lang="ts">
	export let path: [string, string][]
</script>

<nav aria-label="breadcrumb" class="grey-text d-flex flex-wrap">
	<ol class="fs-4 px-0">
		{#each path as [name, href], num}
			<li class="crumb" class:final={num == path.length - 1}>
				{#if num == path.length - 1}
					{name}
				{:else}
					<a {href} class="accent-text">{name}</a>
				{/if}
			</li>
		{/each}
	</ol>
</nav>

<style lang="stylus">
	ol
		list-style none
		display flex
		flex-wrap wrap
		align-items center
		justify-content flex-start

	.crumb:not(:last-child)::after
			content "/"
			margin 0 .5rem
			color var(--grey-text)
			// remove text underline
			text-decoration none
</style>
