<script lang="ts">
	import fade from "$lib/fade"

	export let num: number
	export let total: number
	export let href: string
	export let iconClass = ""
	export let emoji = ""
	export let name: string
</script>

<a
	in:fade|global={{ num, total, duration: 300 }}
	{href}
	class="light-text no-underline">
	<div class="card bg-a light-text p-4 py-6 text-center">
		{#if emoji}
			<span class="text-10">{emoji}</span>
		{:else}
			<fa class="text-10 {iconClass}" />
		{/if}
		<div class="text-xl pt-4">
			{name}
		</div>
		<slot />
	</div>
</a>

<style>
	a .card {
		border: 1px solid var(--accent2);
		transition: background-color 0.2s;
	}
	a:hover .card {
		background-color: var(--background) !important;
	}
</style>
