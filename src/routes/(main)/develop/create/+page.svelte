<script lang="ts">
	export let data

	const assets: any = {
		2: "T-Shirt",
		11: "Shirts",
		12: "Pants",
		13: "Decals",
	}
</script>

<svelte:head>
	<title>Develop - Mercury</title>
</svelte:head>

<div class="container py-2">
	<h1 class="light-text mb-0 text-center">
		Develop - Create <br />
	</h1>
	<h6 class="text-center light-text mb-0">
		<span class="h6 light-text text-center">
			<i class="fas fa-caret-left" />
			<a href="/develop" class="text-decoration-none">Back to Develop</a>
		</span>
	</h6>
</div>
<form method="POST" class="container mt-5 light-text">
	<fieldset>
		<div class="row mb-3">
			<label for="type" class="col-md-3 col-form-label light-text">
				Asset type
			</label>
			<div class="col-md-8">
				<select
					id="type"
					class="form-select"
					aria-label="Asset type select">
					{#each Object.keys(assets) as value}
						<option {value} selected={value == data.assettype}>
							{assets[value]}
						</option>
					{/each}
				</select>
			</div>
		</div>
		<div class="row mb-3">
			<label for="name" class="col-md-3 col-form-label light-text">
				Asset name
			</label>
			<div class="col-md-8">
				<input
					name="name"
					id="name"
					placeholder="Make sure to make it accurate"
					class="form-control" />
			</div>
		</div>
		<div class="row mb-3">
			<label for="description" class="col-md-3 col-form-label light-text">
				Asset description
			</label>
			<div class="col-md-8">
				<textarea
					name="description"
					id="description"
					placeholder="1-1000 characters"
					class="form-control" />
			</div>
		</div>
		<div class="row mb-3">
			<label for="price" class="col-md-3 col-form-label light-text">
				Asset price
			</label>
			<div class="col-md-8">
				<input
					name="price"
					id="price"
					type="number"
					placeholder="0-999 rocks"
					class="form-control" />
			</div>
		</div>
		<div class="row mb-3">
			<label for="asset" class="col-md-3 col-form-label light-text">
				Asset
			</label>
			<div class="col-md-8">
				<input
					name="asset"
					id="asset"
					type="file"
					class="form-control" />
				<small class="light-text">
					Max image size: 20MB. Supported file types: .png, .jpg, .bmp
				</small>
			</div>
		</div>
		<button class="btn btn-success">
			Create Asset ( <i class="fa fa-gem me-1" />
			15 )
		</button>
	</fieldset>
</form>

<style lang="sass">
	@media only screen and (min-width: 576px)
		.container
			width: 50rem

	input
		&[type="checkbox"]
			height: 1.5rem
			width: 1.5rem
		&[type="number"]
			width: 9rem
</style>
