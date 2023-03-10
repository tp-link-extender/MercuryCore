<script lang="ts">
	import { enhance } from "$app/forms"

	let fields = {
		title: "",
		content: "",
	}

	export const snapshot = {
		capture: () => fields,
		restore: v => (fields = v),
	}

	export let data
	export let form
</script>

<svelte:head>
	<title>Create a post in {data.name} - Mercury</title>
</svelte:head>

<h1 class="text-center light-text">Create a post in {data.name}</h1>

<div class="container mt-5 light-text">
	<form use:enhance method="POST">
		<fieldset>
			<div class="row mb-3">
				<label for="title" class="col-md-3 col-form-label text-md-right">Post title</label>
				<div class="col-md-9">
					<input bind:value={fields.title} minlength="5" maxlength="50" type="text" name="title" id="title" placeholder="Make sure to make it accurate" required class="form-control valid" />
				</div>
			</div>
			<div class="row mb-3">
				<label for="content" class="col-md-3 col-form-label text-md-right">Post content</label>
				<div class="col-md-9">
					<textarea bind:value={fields.content} minlength="5" maxlength="3000" rows="6" name="content" id="content" placeholder="50-3000 characters" required class="form-control valid" />
				</div>
			</div>
			<br />
			<button type="submit" class="btn btn-success">Create</button>
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
