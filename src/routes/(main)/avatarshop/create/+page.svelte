<script lang="ts">
	import { superForm } from "sveltekit-superforms/client"

	export let data
	const { form, errors, constraints, enhance, delayed, capture, restore } =
		superForm(data.form, {
			taintedMessage: false,
		})

	export const snapshot = { capture, restore }
	$: other = ($errors as any).other || ""
</script>

<svelte:head>
	<title>Create an avatar item - Mercury</title>
</svelte:head>

<h1 class="text-center light-text">Create an avatar item</h1>

<form use:enhance method="POST" class="container mt-5 light-text">
	<fieldset>
		<div class="grid grid-cols-12 gap-6 mb-3">
			<label for="name" class="md:col-span-3 col-form-label">
				Item name
			</label>
			<div class="md:col-span-8">
				<input
					bind:value={$form.name}
					{...$constraints.name}
					name="name"
					id="name"
					placeholder="Make sure it is descriptive"
					class="form-control {$errors.name ? 'is-in' : ''}valid" />
				<p class="col-span-12 mb-3 text-red-500">
					{$errors.name || ""}
				</p>
			</div>
		</div>
		<div class="grid grid-cols-12 gap-6 mb-3">
			<label for="price" class="md:col-span-3 col-form-label">
				Item price
			</label>
			<div class="md:col-span-8">
				<input
					bind:value={$form.price}
					{...$constraints.price}
					type="number"
					name="price"
					id="price"
					class="form-control {$errors.price ? 'is-in' : ''}valid" />
				<p class="col-span-12 mb-3 text-red-500">
					{$errors.price || ""}
				</p>
			</div>
		</div>
		<div class="grid grid-cols-12 gap-6 mb-4">
			<label for="category" class="md:col-span-3 col-form-label">
				Item category
			</label>
			<div class="md:col-span-8">
				<select
					bind:value={$form.category}
					{...$constraints.category}
					name="category"
					id="category"
					class="form-select {$errors.category ? 'is-in' : ''}valid">
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
				<p class="col-span-12 mb-3 text-red-500">
					{$errors.category || ""}
				</p>
			</div>
		</div>
		<button
			type="submit"
			class="btn bg-emerald-600 hover:bg-emerald-800 text-white">
			{#if $delayed}
				Working...
			{:else}
				Create (
				<i class="fa fa-gem" />
				10 )
			{/if}
		</button>
	</fieldset>
	<p class="col-span-12 mb-3 text-red-500">
		{other}
	</p>
</form>

<style lang="sass">
	@media only screen and (min-width: 576px)
		.container
			width: 50rem
</style>
