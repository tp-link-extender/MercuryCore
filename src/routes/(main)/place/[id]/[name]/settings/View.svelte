<script lang="ts">
	import { page } from "$app/stores"
	import { superForm } from "sveltekit-superforms/client"

	export let data: import("./$types").PageData

	const { form, errors, message, constraints, enhance, delayed } = superForm(
		data.viewForm,
		{
			taintedMessage: false,
		}
	)

	if (data.name && !$form.title) $form.title = data.name
	if (data.description && !$form.description)
		$form.description = data.description.text
</script>

<form use:enhance method="POST" class="col-lg-8" action="?/view&tab=View">
	<fieldset class="pb-6">
		<div class="row">
			<label for="title" class="col-md-3 text-md-right">Title</label>
			<div class="col-md-9">
				<input
					bind:value={$form.title}
					{...$constraints.title}
					required
					id="title"
					name="title"
					class="form-control {$errors.title ? 'is-in' : ''}valid" />
				<p class="col-12 text-danger">
					{$errors.title || ""}
				</p>
			</div>
		</div>
		<div class="row">
			<label for="icon" class="col-md-3 text-md-right">Place Icon</label>
			<div class="col-md-5">
				<input
					bind:value={$form.icon}
					id="icon"
					name="icon"
					type="file"
					accept="image/*"
					class="form-control {$errors.icon ? 'is-in' : ''}valid" />
				<p class="col-12 text-danger">
					{$errors.icon || ""}
				</p>
			</div>
		</div>
		<hr class="grey-text" />
		<div class="row">
			<label for="description" class="light-text">Description</label>
			<div class="ctnr">
				<textarea
					bind:value={$form.description}
					{...$constraints.description}
					required
					placeholder="Up to 1000 characters"
					id="description"
					name="description"
					rows="3"
					class="form-control light-text bg-a {$errors.description
						? 'is-in'
						: ''}valid" />
			</div>
		</div>
	</fieldset>
	<button class="btn btn-success">
		{#if $delayed}
			Working...
		{:else}
			Save changes
		{/if}
	</button>
	<p
		class:text-success={$page.status == 200}
		class:text-danger={$page.status >= 400}>
		{$message || ""}
	</p>
</form>
