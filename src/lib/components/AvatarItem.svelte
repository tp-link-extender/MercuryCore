<script lang="ts">
	// An avatar shop item component, used in the
	// avatar shop and inventory pages.

	export let asset: {
		name: string
		id: number
		wearing: boolean
	}
	export let num: number
	export let total: number
	export let currentTab: string
</script>

<form
	use:enhance
	method="POST"
	class="col-xl-2 col-lg-3 col-md-3 col-sm-4 col-6 text-decoration-none p-0"
	action="/character?/equip&tab={currentTab}&id={asset.id}&a={asset.wearing
		? 'un'
		: ''}equip">
	<button in:fade|global={{ num, total }} class="assetcard px-2">
		<div class="card bg-a3">
			<div class="card-body bg-a p-4 rounded-1">
				<div class="text-center pb-4">
					<img
						src="/avatarshop/{asset.id}/{asset.name}/icon"
						alt={asset.name} />
				</div>
				{#if asset.wearing}
					<span
						class="badge text-bg-primary position-absolute translate-middle">
						Wearing
					</span>
				{/if}
				<p class="m-0">
					{asset.name}
				</p>
			</div>
		</div>
	</button>
</form>

<style lang="stylus">
	button
		background none
		border none

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
