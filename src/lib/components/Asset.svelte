<script lang="ts">
	// An avatar shop item component, used in the
	// avatar shop and inventory pages.

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
	class="col-xl-2 col-lg-3 col-md-3 col-sm-4 col-6 px-2 mb-2 text-decoration-none">
	<div class="card bg-a3 h-100">
		<div class="card-body bg-a p-4 rounded-1">
			<div class="text-center pb-4">
				<img
					src="/avatarshop/{asset.id}/{asset.name}/icon"
					alt={asset.name} />
			</div>
			<p class="m-0">
				{asset.name}
			</p>
			<p class="m-0 text-success">
				<i class="far fa-gem" />
				{asset.price}
			</p>
		</div>
	</div>
</a>

<style lang="stylus">
	.card
		border-width 1px
		border-color var(--accent2)

	a
		.card-body
			transition 0.3s
		&:hover .card-body
			background var(--darker) !important

	img
		width 85%
</style>
