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
		<div class="row mb-3">
			<label for="name" class="col-md-3 col-form-label text-md-right">
				Group name
			</label>
			<div class="col-md-8">
				<input
					bind:value={$form.name}
					{...$constraints.name}
					name="name"
					id="name"
					placeholder="This cannot be changed. Choose wisely."
					class="form-control {$errors.name ? 'is-in' : ''}valid" />
				<p class="col-12 mb-3 text-danger">
					{$errors.name || ""}
				</p>
			</div>
		</div>
		<button class="btn btn-success">
			{#if $delayed}
				Working...
			{:else}
				Create (
				<i class="fa fa-gem" />
				10 )
			{/if}
		</button>
	</fieldset>
	<p class="col-12 mb-3 text-danger">
		{other}
	</p>
</form>

<style lang="stylus">
	@media (min-width 576px)
		.container
			width 50rem
</style>
