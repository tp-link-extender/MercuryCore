<script lang="ts">
	import { superForm } from "sveltekit-superforms/client"

	export let data
	const { form, errors, constraints, enhance, delayed, capture, restore } =
		superForm(data.form, {
			taintedMessage: false,
		})

	export const snapshot = { capture, restore }

	const assets: any = {
		2: "T-Shirt",
		11: "Shirt",
		12: "Pants",
		13: "Decal",
	}
</script>

<Head title="Develop" />

<div class="container py-2">
	<h1 class="light-text mb-0 text-center">
		Develop - Create <br />
	</h1>
	<h6 class="text-center light-text mb-0">
		<span class="h6 light-text text-center">
			<i class="fas fa-caret-left" />
			<a href="/develop" class="no-underline">Back to Develop</a>
		</span>
	</h6>
</div>
<form
	use:enhance
	method="POST"
	class="container mt-12 light-text"
	enctype="multipart/form-data">
	<fieldset>
		<div class="row mb-4">
			<label for="type" class="col-md-3 col-form-label light-text">
				Asset type
			</label>
			<div class="md:col-span-8">
				<select
					bind:value={$form.type}
					{...$constraints.type}
					name="type"
					id="type"
					class="form-select {$errors.type ? 'is-in' : ''}valid"
					aria-label="Asset type select">
					{#each Object.keys(assets) as value}
						<option {value} selected={value == data.assettype}>
							{assets[value]}
						</option>
					{/each}
				</select>
				<p class="col-12 mb-4 text-danger">
					{$errors.type || ""}
				</p>
			</div>
		</div>
		<div class="row mb-4">
			<label for="name" class="col-md-3 col-form-label light-text">
				Asset name
			</label>
			<div class="md:col-span-8">
				<input
					bind:value={$form.name}
					{...$constraints.name}
					name="name"
					id="name"
					placeholder="Make sure to make it accurate"
					class="form-control {$errors.name ? 'is-in' : ''}valid" />
				<p class="col-12 mb-4 text-danger">
					{$errors.name || ""}
				</p>
			</div>
		</div>
		<div class="row mb-4">
			<label for="description" class="col-md-3 col-form-label light-text">
				Asset description
			</label>
			<div class="md:col-span-8">
				<textarea
					bind:value={$form.description}
					{...$constraints.description}
					name="description"
					id="description"
					placeholder="1-1000 characters"
					class="form-control {$errors.description
						? 'is-in'
						: ''}valid" />
				<p class="col-12 mb-4 text-danger">
					{$errors.description || ""}
				</p>
			</div>
		</div>
		<div class="row mb-4">
			<label for="price" class="col-md-3 col-form-label light-text">
				Asset price
			</label>
			<div class="md:col-span-8">
				<input
					bind:value={$form.price}
					{...$constraints.price}
					name="price"
					id="price"
					type="number"
					class="form-control {$errors.price ? 'is-in' : ''}valid" />
				<p class="col-12 mb-4 text-danger">
					{$errors.price || ""}
				</p>
			</div>
		</div>
		<div class="row mb-4">
			<label for="asset" class="col-md-3 col-form-label light-text">
				Asset
			</label>
			<div class="md:col-span-8">
				<input
					bind:value={$form.asset}
					{...$constraints.asset}
					name="asset"
					id="asset"
					type="file"
					required
					class="form-control {$errors.asset ? 'is-in' : ''}valid" />
				<small class="light-text">
					Max image size: 20MB. Supported file types: .png, .jpg, .bmp
				</small>
				<p class="col-12 mb-4 text-danger">
					{$errors.asset || ""}
				</p>
			</div>
		</div>

		<button class="btn bg-emerald-600 hover:bg-emerald-800 text-white">
			{#if $delayed}
				Working...
			{:else}
				Create (
				<i class="fa fa-gem" />
				15 )
			{/if}
		</button>
	</fieldset>
</form>

<style lang="stylus">
	containerMinWidth()

	input[type="number"]
		width 9rem
</style>
