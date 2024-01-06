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
	class="no-underline"
	action="/character?/{asset.wearing
		? 'un'
		: ''}equip&tab={currentTab}&id={asset.id}">
	<button
		in:fade|global={{ num, total }}
		class="card bg-a assetcard h-full p-4">
		<div class="text-center pb-4">
			<img
				class="w-85%"
				src="/avatarshop/{asset.id}/{asset.name}/icon"
				alt={asset.name} />
		</div>
		{#if asset.wearing}
			<div class="top-0 end-0 absolute">
				<small class="p-2 py-1 rounded-1.5 font-bold bg-blue-5">
					Wearing
				</small>
			</div>
		{/if}
		<span class="text-base">
			{asset.name}
		</span>
	</button>
</form>

<style lang="stylus">
	.card
		border 1px solid var(--accent2)

	.assetcard
		transition 0.3s
		&:hover
			background var(--darker) !important
</style>
