<script lang="ts">
	// An equippable avatar item component

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
	class="col-xl-2 col-lg-3 col-md-3 col-sm-4 col-6 no-underline p-0"
	action="/character?/{asset.wearing
		? 'un'
		: ''}equip&tab={currentTab}&id={asset.id}">
	<button in:fade|global={{ num, total }} class="assetcard px-2">
		<div class="card bg-a3">
			<div class="card-body bg-a p-4 rounded-1">
				<div class="text-center pb-4">
					<img
						src="/avatarshop/{asset.id}/{asset.name}/icon"
						alt={asset.name} />
				</div>
				{#if asset.wearing}
					<div
						class="top-0 end-0 pr-1 absolute
						translate-middle">
						<small
							class="text-light p-2 py-1 rounded-3
							font-bold bg-primary">
							Wearing
						</small>
					</div>
				{/if}
				<span class="text-base">
					{asset.name}
				</span>
			</div>
		</div>
	</button>
</form>

<style lang="stylus">
	button
		background none
		border none

	.card
		border 1px solid var(--accent2)

	.assetcard
		.card-body
			transition 0.3s
		&:hover .card-body
			background var(--darker) !important

	img
		width 85%
</style>
