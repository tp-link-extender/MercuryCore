<script lang="ts">
	// An avatar shop item component, used in the
	// avatar shop and inventory pages.

	import fade from "$lib/fade"

	export let asset: {
		id: string
		name: string
		price: number
		// ratio?: string | number
	}
	export let num: number
	export let total: number
</script>

<a
	in:fade={{ num, total }}
	href="/"
	class="col-xl-2 col-lg-3 col-md-3 col-sm-4 col-6 px-2 mb-2 text-decoration-none assetcard">
	<div class="card bg-a3">
		<div class="card-body bg-a p-3 rounded-1">
			<div class="text-center pb-3">
				<img
					class="w-85"
					alt={asset.name}
					src="https://clipground.com/images/clipart-traffic-cone-7.png" />
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

<style lang="sass">
	.card
		border-width: 2px

	.assetcard
		.card-body
			transition: 0.3s
		&:hover
			.card-body
				background: var(--darker) !important
</style>
