<script lang="ts">
	// An avatar shop item component, used in the
	// avatar shop and inventory pages.

	export let asset: import("./$types").PageData["assets"][0]
	export let num: number
	export let total: number

	let modal: HTMLInputElement
</script>

<label
	in:fade|global={{ num, total }}
	for="modal{asset.id}"
	class="assetcard col-xl-2 col-lg-3 col-md-3 col-sm-4 col-6
	text-decoration-none px-2">
	<div class="card bg-a3">
		<div class="card-body bg-a p-4 pb-3 rounded-1 light-text">
			<div class="text-center pb-4">
				<img
					src="/avatarshop/{asset.id}/{asset.name}/icon"
					alt={asset.name} />
			</div>
			{asset.name}
			<span class="d-flex">
				<strong class="pe-2">by</strong>
				<User
					user={asset.creator}
					size="1.5rem"
					thin
					full
					bg="background" />
			</span>
			<div class="btn-group mt-2">
				<form
					use:enhance
					method="POST"
					action="/admin/asset?id={asset.id}&a=approve"
					class="d-inline">
					<button class="btn btn-sm btn-primary mb-1">Approve</button>
				</form>
				<form
					use:enhance
					method="POST"
					action="/admin/asset?id={asset.id}&a=approve"
					class="d-inline">
					<button class="btn btn-sm btn-danger mb-1">Deny</button>
				</form>
			</div>
		</div>
	</div>
</label>

<input
	type="checkbox"
	id="modal{asset.id}"
	class="modal-toggle"
	bind:this={modal} />
<div class="modal2 light-text">
	<div
		class="modal-box d-flex flex-column p-4 text-center"
		style="width: 25rem">
		<h2 class="fs-4">Asset {asset.name}</h2>
		{#if asset.imageAsset}
			<div class="text-center pb-2">
				<h3 class="fs-5">Image asset</h3>
				<img
					class="image"
					src="/avatarshop/{asset.imageAsset.id}/{asset.imageAsset
						.name}/icon"
					alt={asset.imageAsset.name} />
			</div>

			<label for="purge{asset.id}" class="btn btn-lg btn-danger mt-3">
				Purge
			</label>
			
			<label for="purge{asset.id}" class="btn btn-lg btn-primary mt-3">
				Re-render
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
	<div class="modal-box p-4" style="width: 30rem">
		<h2 class="fs-4">Purge {asset.name}</h2>

		<p>Are you sure you want to purge this asset?</p>
		<p>
			<strong>
				This cannot be undone! It will permanently delete the asset, its
				related image asset, and all thumbnails and data associated with
				it.
			</strong>
		</p>

		<form
			use:enhance
			method="POST"
			action="/admin/asset?id={asset.id}&a=purge"
			class="d-inline">
			<button
				class="btn btn-danger"
				style="background: #930010;
				border-color: #930010">
				Yes, do as I say!
			</button>
		</form>
		<label for="purge{asset.id}" class="btn btn-dark ms-2">
			Misinput MISINPUT
		</label>
	</div>
	<label class="modal-backdrop" for="purge{asset.id}">Close</label>
</div>

<style lang="stylus">
	.card
		border-width 2px

	.assetcard
		cursor pointer
		.card-body
			transition 0.3s
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

		height 20rem
		width 20rem

		+-sm()
			height 15rem
			width 15rem

	label img
		width 85%
</style>
