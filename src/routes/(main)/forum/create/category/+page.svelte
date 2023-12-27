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
</script>

<Head title="Create a forum category" />

<h1 class="text-center">Create a forum category</h1>

<div class="ctnr pt-12 max-w-200 light-text">
	<form use:enhance method="POST">
		<fieldset>
			<div class="row pb-4">
				<label for="name" class="col-md-3">Category name</label>
				<div class="col-md-9">
					<input
						bind:value={$form.name}
						{...$constraints.name}
						name="name"
						id="name"
						placeholder="Make sure to make it accurate"
						class="form-control {$errors.name
							? 'is-in'
							: ''}valid" />

					<small class="col-12 pb-4 text-danger">
						{$errors.name || ""}
					</small>
				</div>
			</div>
			<div class="row pb-8">
				<label for="description" class="col-md-3">
					Category description
				</label>
				<div class="col-md-9">
					<input
						bind:value={$form.description}
						{...$constraints.description}
						name="description"
						id="description"
						placeholder="Give it some further detail"
						class="form-control {$errors.description
							? 'is-in'
							: ''}valid" />

					<small class="col-12 pb-4 text-danger">
						{$errors.description || ""}
					</small>
				</div>
			</div>
			<button class="btn btn-success">
				{#if $delayed}
					Working...
				{:else}
					Create
				{/if}
			</button>
		</fieldset>
	</form>
	<p
		class:text-success={$page.status == 200}
		class:text-danger={$page.status >= 400}>
		{$message || ""}
	</p>
	<br />
</div>
