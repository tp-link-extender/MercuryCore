<script lang="ts">
	// An avatar shop item component, used in the
	// avatar shop and inventory pages.

	export let asset: {
		id: number
		name: string
		// ratio?: string | number
	}
	export let num: number
	export let total: number
</script>

<a
	in:fade|global={{ num, total }}
	href="/avatarshop/{asset.id}/{asset.name}"
	class="col-xl-2 col-lg-3 col-md-3 col-sm-4 col-6 px-2 mb-2 text-decoration-none assetcard">
	<div class="card bg-a3">
		<div class="card-body bg-a p-4 rounded-1">
			<div class="text-center pb-4">
				<img
					src="/avatarshop/{asset.id}/{asset.name}/icon"
					alt={asset.name} />
			</div>
            <span class="badge text-bg-primary position-absolute translate-middle">Wearing</span>
			<p class="m-0">
				{asset.name}
			</p>
		</div>
	</div>
</a>

<style lang="stylus">
	.card
		border-width 2px

	.assetcard
		.card-body
			transition 0.3s
		&:hover
			.card-body
				background var(--darker) !important

	img
		width 85%
    
    .badge
		top 2% 
		right 5%
</style>
