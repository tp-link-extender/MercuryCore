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
	class="col-lg-3 p-1 no-underline">
	<div class="px-0 card bg-a3 text-center light-text shadow-none">
		<div class="card-body bg-a rounded-1 p-6">
			{#if emoji}
				<span class="icon">{emoji}</span>
			{:else}
				<i class="icon {iconClass}" />
			{/if}
			<div class="fs-3 mt-4">
				{name}
			</div>
			<slot />
		</div>
	</div>
</a>

<style lang="stylus">
	.icon
		font-size 2.5rem

	a 
		.card-body
			transition background-color 0.2s
		&:hover .card-body
			background-color var(--background) !important

	.card
		border 1px solid var(--accent2)
</style>
