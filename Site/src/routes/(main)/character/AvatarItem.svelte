<script lang="ts">
	// An equippable avatar item component

	import { enhance } from "$app/forms"
	import fade from "$lib/fade"

	const {
		asset,
		num,
		total,
		currentTab,
		enhanceRegen
	}: {
		asset: {
			name: string
			id: number
			wearing: boolean
		}
		num: number
		total: number
		currentTab: string
		enhanceRegen: import("./$types").SubmitFunction
	} = $props()
</script>

<form
	use:enhance={enhanceRegen}
	method="POST"
	action="/character?/{asset.wearing
		? 'un'
		: ''}equip&tab={currentTab}&id={asset.id}"
	class="no-underline">
	<button
		in:fade|global={{ num, total }}
		class="card bg-a assetcard size-full p-4 cursor-pointer">
		{#if asset.wearing}
			<small
				class="top-0 end-0 absolute p-2 py-1 rounded-1.5 font-bold bg-blue-500">
				Wearing
			</small>
		{/if}
		<div class="text-center w-full pb-4">
			<img
				class="w-85%"
				src="/catalog/{asset.id}/{asset.name}/icon"
				alt={asset.name} />
		</div>
		<span class="text-base w-full">
			{asset.name}
		</span>
	</button>
</form>

<style>
	.card {
		border: 1px solid var(--accent2);
	}

	.assetcard {
		transition: 0.3s;
		&:hover {
			background: var(--darker);
		}
	}
</style>
