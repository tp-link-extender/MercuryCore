<script lang="ts">
	import type { Snippet } from "svelte"
	import type { ClassValue } from "svelte/elements"
	import fade from "$lib/fade"

	const {
		num,
		total,
		href,
		iconClass = "",
		emoji = "",
		name,
		children
	}: {
		num: number
		total: number
		href: string
		iconClass?: ClassValue
		emoji?: string
		name: string
		children?: Snippet
	} = $props()
</script>

<a
	in:fade|global={{ num, total, duration: 300 }}
	{href}
	class="light-text no-underline">
	<div class="card bg-a light-text p-4 py-6 text-center">
		{#if emoji}
			<span class="text-10">{emoji}</span>
		{:else}
			<fa class={["text-10", iconClass]}></fa>
		{/if}
		<div class="text-xl pt-4">
			{name}
		</div>
		{@render children?.()}
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
