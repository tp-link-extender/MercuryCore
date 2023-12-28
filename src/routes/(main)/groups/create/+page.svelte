<script lang="ts">
	import superForm from "$lib/superForm"

	export let data
	const { form, errors, constraints, enhance, delayed, capture, restore } =
		superForm(data.form)

	export const snapshot = { capture, restore }
	$: other = ($errors as any).other || ""
</script>

<Head title="Create a group" />

<h1 class="text-center">Create a group</h1>

<form use:enhance method="POST" class="ctnr pt-12 max-w-200 light-text">
	<fieldset>
		<div class="row mb-4">
			<label for="name" class="col-md-3 text-md-right">Group name</label>
			<div class="col-md-8">
				<input
					bind:value={$form.name}
					{...$constraints.name}
					name="name"
					id="name"
					placeholder="This cannot be changed. Choose wisely."
					class="form-control {$errors.name ? 'is-in' : ''}valid" />
				<p class="col-12 mb-4 text-danger">
					{$errors.name || ""}
				</p>
			</div>
		</div>
		<button class="btn btn-success">
			{#if $delayed}
				Working...
			{:else}
				Create ( <fa fa-gem />
				10 )
			{/if}
		</button>
	</fieldset>
	<p class="col-12 mb-4 text-danger">
		{other}
	</p>
</form>
