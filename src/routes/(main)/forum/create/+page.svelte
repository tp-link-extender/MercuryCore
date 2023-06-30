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

<svelte:head>
	<title>Create a post in {data.category.name} - Mercury</title>
</svelte:head>

<h1 class="text-center light-text">Create a post in {data.category.name}</h1>

<div class="container mt-5 light-text">
	<form use:enhance method="POST">
		<fieldset>
			<div class="row mb-3">
				<label for="title" class="col-md-3 col-form-label">
					Post title
				</label>
				<div class="col-md-9">
					<input
						bind:value={$form.title}
						{...$constraints.title}
						name="title"
						id="title"
						placeholder="Make sure to make it accurate"
						class="form-control {$errors.title
							? 'is-in'
							: ''}valid" />

					<small class="col-12 mb-3 text-danger">
						{$errors.title || ""}
					</small>
				</div>
			</div>
			<div class="row mb-3">
				<label for="content" class="col-md-3 col-form-label">
					Post content
				</label>
				<div class="col-md-9">
					<textarea
						bind:value={$form.content}
						{...$constraints.content}
						rows="6"
						name="content"
						id="content"
						placeholder="50-3000 characters"
						class="form-control {$errors.content
							? 'is-in'
							: ''}valid" />

					<small class="col-12 mb-3 text-danger">
						{$errors.content || ""}
					</small>
				</div>
			</div>
			<button class="btn btn-success my-3">
				{#if $delayed}
					Working...
				{:else}
					Post
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

<style lang="sass">
	@media only screen and (min-width: 576px)
		.container
			width: 50rem
</style>
