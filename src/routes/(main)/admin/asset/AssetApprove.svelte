<script lang="ts">
	// An avatar shop item component, used in the avatar shop and inventory pages.

	export let asset: import("./$types").PageData["assets"][0]
	export let num: number
	export let total: number

	let modal: HTMLInputElement
</script>

<label
	in:fade|global={{ num, total }}
	for="modal{asset.id}"
	class="card no-underline p-3 cursor-pointer duration-300">
	<div class="text-center pb-4">
		<img
			src="/avatarshop/{asset.id}/{asset.name}/icon"
			alt={asset.name}
			class="w-85%" />
	</div>
	{asset.name}
	<span class="flex pb-2">
		<strong class="pr-2">by</strong>
		<User user={asset.creator} size="1.5rem" thin full bg="background" />
	</span>
	<div>
		<form
			use:enhance
			method="POST"
			action="/admin/asset?/approve&id={asset.id}">
			<button class="w-full btn btn-sm btn-secondary">Approve</button>
		</form>
		<form
			use:enhance
			method="POST"
			action="/admin/asset?/deny&id={asset.id}">
			<button class="w-full btn btn-sm btn-red-secondary">Deny</button>
		</form>
	</div>
</label>

<input
	type="checkbox"
	id="modal{asset.id}"
	class="modal-toggle"
	bind:this={modal} />
<div class="modal2 light-text">
	<div class="modal-box flex flex-col p-4 text-center" style="width: 25rem">
		<h2 class="text-base">Asset {asset.name}</h2>
		{#if asset.imageAsset}
			<div class="text-center pb-3">
				<h3 class="text-xs">Image asset</h3>
				<img
					class="image aspect-1 md:w-80 w-60"
					src="/avatarshop/{asset.imageAsset.id}/{asset.imageAsset
						.name}/icon"
					alt={asset.imageAsset.name} />
			</div>

			<form
				use:enhance
				method="POST"
				action="/admin/asset?/rerender&id={asset.id}"
				class="w-full pb-3">
				<button class="btn btn-lg btn-primary w-full">
					<fa fa-arrows-rotate class="pr-1" />
					Rerender
				</button>
			</form>
			<label for="purge{asset.id}" class="btn btn-lg btn-red-tertiary">
				<fa fa-trash-xmark class="pr-1" />
				Purge
			</label>
		{/if}
	</div>
	<label class="modal-backdrop" for="modal{asset.id}">Close</label>
</div>

<input
	type="checkbox"
	id="purge{asset.id}"
	class="modal-toggle"
	bind:this={modal} />
<div class="modal2 light-text">
	<div class="modal-box p-4 max-w-120">
		<h2 class="text-base">Purge {asset.name}</h2>

		<p>Are you sure you want to purge this asset?</p>
		<p>
			<strong>
				This cannot be undone! It will permanently delete the asset, its
				related image asset, and all thumbnails and data associated with
				it.
			</strong>
			Treat this as a last resort &ndash; the nuclear option.
		</p>

		<div class="flex flex-wrap gap-3">
			<form
				use:enhance
				method="POST"
				action="/admin/asset?/purge&id={asset.id}">
				<button class="btn btn-danger bg-red-9 border-red-9">
					Yes, do as I say!
				</button>
			</form>
			<label for="purge{asset.id}" class="btn btn-dark">
				Misinput MISINPUT
			</label>
		</div>
	</div>
	<label class="modal-backdrop" for="purge{asset.id}">Close</label>
</div>

<style lang="stylus">
	.card
		border 1px solid var(--accent2)
		&:hover
			background var(--darker) !important

	.image
		background var(--accent)
		background-image:
			linear-gradient(45deg,
				var(--darker) 25%, transparent 25%,
				transparent 75%, var(--darker) 75%
			),
			linear-gradient(45deg,
				var(--darker) 25%, transparent 25%,
				transparent 75%, var(--darker) 75%
			)
		background-size 20px 20px
		background-position 0 0, 10px 10px
</style>
