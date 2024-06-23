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
	<div class=" card bg-a3 light-text px-0 text-center">
		<div class="card-body bg-a rounded-1 p-6">
			{#if emoji}
				<span class="text-10">{emoji}</span>
			{:else}
				<i class="text-10 {iconClass}" />
			{/if}
			<div class="text-xl pt-4">
				{name}
			</div>
			<slot />
		</div>
	</div>
</a>

<style>
	a {
		& .card-body {
			transition: background-color 0.2s;
		}
		&:hover .card-body {
			background-color: var(--background) !important;
		}
	}

	.card {
		border: 1px solid var(--accent2);
	}
</style>
