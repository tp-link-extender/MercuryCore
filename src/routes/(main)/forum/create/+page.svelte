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
			<div class="grid grid-cols-12 gap-6 mb-3">
				<label for="title" class="md:col-span-3 col-form-label">
					Post title
				</label>
				<div class="md:col-span-9">
					<input
						bind:value={$form.title}
						{...$constraints.title}
						name="title"
						id="title"
						placeholder="Make sure to make it accurate"
						class="form-control {$errors.title
							? 'is-in'
							: ''}valid" />

					<small class="col-span-12 mb-3 text-red-500">
						{$errors.title || ""}
					</small>
				</div>
			</div>
			<div class="grid grid-cols-12 gap-6 mb-3">
				<label for="content" class="md:col-span-3 col-form-label">
					Post content
				</label>
				<div class="md:col-span-9">
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

					<small class="col-span-12 mb-3 text-red-500">
						{$errors.content || ""}
					</small>
				</div>
			</div>
			<button
				class="btn bg-emerald-600 hover:bg-emerald-800 text-white my-3">
				{$delayed ? "Working..." : "Post"}
			</button>
		</fieldset>
	</form>
	<p
		class:text-emerald-500={$page.status == 200}
		class:text-red-500={$page.status >= 400}>
		{$message || ""}
	</p>
	<br />
</div>

<style lang="sass">
	@media only screen and (min-width: 576px)
		.container
			width: 50rem
</style>
