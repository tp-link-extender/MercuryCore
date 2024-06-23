<script lang="ts">
	// An avatar shop item component, used in the avatar shop and inventory pages.

	import fade from "$lib/fade"

	export let asset: {
		id: number
		name: string
		price: number
		// ratio?: string | number
	}
	export let num: number
	export let total: number
</script>

<a
	in:fade|global={{ num, total }}
	href="/avatarshop/{asset.id}/{asset.name}"
	class="no-underline">
	<div class="card bg-a3 h-full">
		<div class="card-body bg-a p-4 rounded-1">
			<div class="text-center pb-4">
				<img
					src="/avatarshop/{asset.id}/{asset.name}/icon"
					alt={asset.name} />
			</div>
			<p class="m-0">
				{asset.name}
			</p>
			<p class="m-0 text-emerald-6">
				<far fa-gem />
				{asset.price}
			</p>
		</div>
	</div>
</a>

<style lang="stylus">
	.card
		border 1px solid var(--accent2)

	a
		.card-body
			transition 0.3s
		&:hover .card-body
			background var(--darker) !important

	img
		width 85%
</style>
