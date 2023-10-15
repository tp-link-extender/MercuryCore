<script lang="ts">
	// An avatar shop item component, used in the
	// avatar shop and inventory pages.

	export let asset: import("../../routes/(main)/admin/asset/$types").PageData["assets"][0]
	export let num: number
	export let total: number

	let modal: HTMLInputElement
</script>

<label
	in:fade|global={{ num, total }}
	for="modal{asset.id}"
	class="col-xl-2 col-lg-3 col-md-3 col-sm-4 col-6
		text-decoration-none assetcard px-2">
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
	<div class="modal-box d-flex flex-column p-4 text-center">
		<h2 class="fs-4">Asset {asset.name}</h2>
		{#if asset.imageAsset}
			<div class="text-center">
				<h3 class="fs-5">Image asset</h3>
				<img
					class="image"
					src="/avatarshop/{asset.imageAsset.id}/{asset.imageAsset
						.name}/icon"
					alt={asset.imageAsset.name} />
			</div>
		{/if}
	</div>
	<label class="modal-backdrop" for="modal{asset.id}">Close</label>
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

	.modal-box
		width 25rem

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
