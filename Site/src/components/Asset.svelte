<script lang="ts">
	// A catalog item component, used in the catalog and inventory pages.

	import fade from "$lib/fade"

	export let asset: {
		id: number
		name: string
		price: number
		// ratio?: string | number
	}
	export let num: number
	export let total: number
	export let symbol: string
</script>

<a
	in:fade|global={{ num, total }}
	href="/catalog/{asset.id}/{asset.name}"
	class="card bg-a h-full p-4 no-underline">
	<div class="text-center pb-4">
		<img
			src="/catalog/{asset.id}/{asset.name}/icon"
			alt={asset.name}
			class="w-85%" />
	</div>
	<p>{asset.name}</p>
	<p class="text-emerald-600">{symbol}{asset.price}</p>
</a>

<style>
	.card {
		border: 1px solid var(--accent2);
		transition: 0.3s;
		&:hover {
			background: var(--darker) !important;
		}
	}
</style>
