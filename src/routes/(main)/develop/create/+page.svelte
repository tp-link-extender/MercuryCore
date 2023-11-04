<script lang="ts">
	import { page } from "$app/stores"
	import { superForm } from "sveltekit-superforms/client"

	export let data
	const {
		form,
		errors,
		message,
		constraints,
		enhance,
		delayed,
		capture,
		restore,
	} = superForm(data.form, {
		taintedMessage: false,
	})

	export const snapshot = { capture, restore }

	const assets: { [k: string]: string } = {
		"2": "T-Shirt",
		"11": "Shirt",
		"12": "Pants",
		"13": "Decal",
	}

	if (data.user.permissionLevel > 3) {
		// assets["8"] = "Hat"
		assets["18"] = "Face"
	}
</script>

<Head title="Develop" />

<div class="container py-2">
	<h1 class="mb-0 text-center">
		Develop - Create <br />
	</h1>
	<div class="text-center">
		<a href="/develop" class="text-decoration-none accent-text">
			<fa fa-caret-left />

			Back to Develop
		</a>
	</div>
</div>
<form
	use:enhance
	method="POST"
	class="container pt-8 light-text"
	enctype="multipart/form-data">
	<fieldset>
		<div class="row pb-4">
			<label for="type" class="col-md-3 light-text">Asset type</label>
			<div class="col-md-8">
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
				<p class="text-danger">
					{$errors.type || ""}
				</p>
			</div>
		</div>
		<div class="row pb-4">
			<label for="name" class="col-md-3 light-text">Asset name</label>
			<div class="col-md-8">
				<input
					bind:value={$form.name}
					{...$constraints.name}
					name="name"
					id="name"
					placeholder="Make sure to make it accurate"
					class="form-control {$errors.name ? 'is-in' : ''}valid" />
				<p class="text-danger">
					{$errors.name || ""}
				</p>
			</div>
		</div>
		<div class="row pb-4">
			<label for="description" class="col-md-3 light-text">
				Asset description
			</label>
			<div class="col-md-8">
				<textarea
					bind:value={$form.description}
					{...$constraints.description}
					name="description"
					id="description"
					placeholder="Up to 1000 characters"
					class="form-control {$errors.description
						? 'is-in'
						: ''}valid" />
				<p class="text-danger">
					{$errors.description || ""}
				</p>
			</div>
		</div>
		<div class="row pb-4">
			<label for="price" class="col-md-3 light-text">Asset price</label>
			<div class="col-md-8">
				<input
					bind:value={$form.price}
					{...$constraints.price}
					name="price"
					id="price"
					type="number"
					class="form-control {$errors.price ? 'is-in' : ''}valid" />
				<p class="text-danger">
					{$errors.price || ""}
				</p>
			</div>
		</div>
		<div class="row pb-4">
			<label for="asset" class="col-md-3 light-text">Asset</label>
			<div class="col-md-8">
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
				<p class="text-danger">
					{$errors.asset || ""}
				</p>
			</div>
		</div>

		<p
			class:text-success={$page.status == 200}
			class:text-danger={$page.status >= 400}>
			{$message || ""}
		</p>

		<button class="btn btn-success">
			{#if $delayed}
				Working...
			{:else}
				Create ( <fa fa-gem />
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
