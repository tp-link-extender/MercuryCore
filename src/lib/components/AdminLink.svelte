<script lang="ts">
	export let num: number
	export let total: number
	export let href: string
	export let iconClass: string = ""
	export let emoji: string = ""
	export let name: string
</script>

<a
	in:fade|global={{ num, total, duration: 300 }}
	{href}
	class="col-lg-3 p-1 text-decoration-none">
	<div class="px-0 card bg-a3 text-center light-text">
		<div class="card-body bg-a rounded-1 p-6">
			{#if emoji}
				<span class="h1">{emoji}</span>
			{:else}
				<i class="h1 {iconClass}" />
			{/if}
			<h4 class="h5 mt-4">
				{name}
			</h4>
			<slot />
		</div>
	</div>
</a>

<style lang="stylus">
	a .card-body
		transition background-color 0.2s
		&:hover
			background-color var(--background) !important

	.card
		border-width 2px
		border-color var(--accent3)
</style>
