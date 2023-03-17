<script lang="ts">
	import { enhance } from "$app/forms"

	let fields = {
		name: "",
		price: "",
		category: "",
	}

	export const snapshot = {
		capture: () => fields,
		restore: v => (fields = v),
	}

	export let form
</script>

<svelte:head>
	<title>Create an avatar item - Mercury</title>
</svelte:head>

<h1 class="text-center light-text">Create an avatar item</h1>

<div class="container mt-5 light-text">
	<form use:enhance method="POST">
		<fieldset>
			<div class="row">
				<label for="name" class="col-md-3 col-form-label text-md-right">
					Item name
				</label>
				<div class="col-md-8">
					<input
						bind:value={fields.name}
						type="text"
						name="name"
						id="name"
						required
						class="form-control valid"
						minlength="3"
						maxlength="50" />
				</div>
			</div>
			<br />
			<div class="row">
				<label
					for="price"
					class="col-md-3 col-form-label text-md-right">
					Item price
				</label>
				<div class="col-md-8">
					<input
						bind:value={fields.price}
						type="number"
						name="price"
						id="price"
						required
						class="form-control valid"
						min="0" />
				</div>
			</div>
			<br />
			<div class="row">
				<label
					for="category"
					class="col-md-3 col-form-label text-md-right">
					Item category
				</label>
				<div class="col-md-8">
					<select
						bind:value={fields.category}
						name="category"
						id="category"
						class="form-select valid">
						<option value="TShirt">T-Shirt</option>
						<option value="Shirt">Shirt</option>
						<option value="Pants">Pants</option>
						<option value="HeadShape">Head shape</option>
						<option value="Hair">Hair</option>
						<option value="Face">Face</option>
						<option value="Skirt">Skirt</option>
						<option value="Dress">Dress</option>
						<option value="Hat">Hat</option>
						<option value="Headgear">Headgear</option>
						<option value="Gear">Gear</option>
						<option value="Neck">Neck</option>
						<option value="Back">Back</option>
						<option value="Shoulder">Shoulder</option>
					</select>
				</div>
			</div>
			<br />
			<button type="submit" class="btn btn-success">
				Create (
				<i class="fa fa-gem" />
				10)
			</button>
		</fieldset>
	</form>
	<br />
	<p class="col-12 mb-3 text-danger">{form?.msg || ""}</p>
</div>

<style lang="sass">
	@media only screen and (min-width: 576px)
		.container
			width: 50rem
</style>
