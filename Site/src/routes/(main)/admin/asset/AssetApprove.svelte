<script lang="ts">
	import { enhance } from "$app/forms"
	import User from "$components/User.svelte"
	import fade from "$lib/fade"

	interface Props {
		asset: import("./$types").PageData["assets"][0];
		num: number;
		total: number;
	}

	let { asset, num, total }: Props = $props();
</script>

<div in:fade|global={{ num, total }} class="card duration-300">
	<button
		id="open"
		class="bg-transparent p-0 border-0 cursor-pointer p-3"
		popovertarget="modal{asset.id}">
		<div class="text-center pb-2">
			<img
				src="/catalog/{asset.id}/{asset.name}/icon"
				alt={asset.name}
				class="w-85%" />
		</div>
		{asset.name}
		<span class="flex">
			<strong class="pr-2">by</strong>
			<User
				user={asset.creator}
				size="1.5rem"
				thin
				full
				bg="background" />
		</span>
	</button>
	<div class="flex flex-col gap-1 p-3">
		<form
			use:enhance
			method="POST"
			action="/admin/asset?/approve&id={asset.id}">
			<button class="btn btn-sm btn-secondary w-full">Approve</button>
		</form>
		<form
			use:enhance
			method="POST"
			action="/admin/asset?/deny&id={asset.id}">
			<button class="btn btn-sm btn-red-secondary w-full">Deny</button>
		</form>
	</div>
</div>

<div
	id="modal{asset.id}"
	class="light-text p-4 text-center w-100"
	popover="auto">
	<h2 class="text-base">Asset {asset.name}</h2>
	{#if asset.imageAsset}
		<div class="text-center pb-3">
			<h3 class="text-xs pb-3">Image asset</h3>
			<img
				class="image aspect-1 md:w-80 w-60"
				src="/catalog/{asset.imageAsset.id}/{asset.imageAsset
					.name}/icon"
				alt={asset.imageAsset.name} />
		</div>

		<form
			use:enhance
			method="POST"
			action="/admin/asset?/rerender&id={asset.id}"
			class="w-full pb-3">
			<button class="btn btn-lg btn-primary w-full">
				<fa fa-arrows-rotate class="pr-1"></fa>
				Rerender
			</button>
		</form>
		<button
			popovertarget="purge{asset.id}"
			class="btn btn-lg btn-red-tertiary w-full">
			<fa fa-trash-xmark class="pr-1"></fa>
			Purge
		</button>
	{/if}
</div>

<div id="purge{asset.id}" class="light-text p-4 max-w-120" popover="auto">
	<h2 class="text-base">Purge {asset.name}</h2>

	<p>Are you sure you want to purge this asset?</p>
	<p>
		<strong>
			This cannot be undone! It will permanently delete the asset, its
			related image asset, and all thumbnails and data associated with it.
		</strong>
		Treat this as a last resort &ndash; the nuclear option.
	</p>

	<div class="flex flex-wrap gap-3">
		<form
			use:enhance
			method="POST"
			action="/admin/asset?/purge&id={asset.id}">
			<button class="btn btn-danger bg-red-900 border-red-900">
				Yes, do as I say!
			</button>
		</form>
		<button
			class="btn btn-dark"
			popovertarget="purge{asset.id}"
			popovertargetaction="hide">
			Misinput MISINPUT
		</button>
	</div>
</div>

<style>
	.card {
		border: 1px solid var(--accent2);
	}
	.card:has(:global(#open:hover)) {
		background: var(--darker);
	}

	.image {
		background: var(--accent);
		background-image: linear-gradient(
				45deg,
				var(--darker) 25%,
				transparent 25%,
				transparent 75%,
				var(--darker) 75%
			),
			linear-gradient(
				45deg,
				var(--darker) 25%,
				transparent 25%,
				transparent 75%,
				var(--darker) 75%
			);
		background-size: 20px 20px;
		background-position:
			0 0,
			10px 10px;
	}
</style>
