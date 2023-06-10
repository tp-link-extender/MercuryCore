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
	<title>Create a group - Mercury</title>
</svelte:head>

<h1 class="text-center light-text">Create a group</h1>

<form use:enhance method="POST" class="container mt-5 light-text">
	<fieldset>
		<div class="grid grid-cols-12 gap-6 mb-3">
			<label
				for="name"
				class="md:col-span-3 col-form-label text-md-right">
				Group name
			</label>
			<div class="md:col-span-8">
				<input
					bind:value={$form.name}
					{...$constraints.name}
					name="name"
					id="name"
					placeholder="This cannot be changed. Choose wisely."
					class="form-control {$errors.name ? 'is-in' : ''}valid" />
				<p class="col-span-12 mb-3 text-red-500">
					{$errors.name || ""}
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
