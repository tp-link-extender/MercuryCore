<script lang="ts">
	import type { ActionData, PageData } from "./$types"
	import { enhance } from "$app/forms"

	export let form: ActionData
</script>

<svelte:head>
	<title>Create a place - Mercury</title>
</svelte:head>

<h1 class="text-center light-text">Create a place</h1>

<div class="container mt-5 light-text">
	<form use:enhance method="POST">
		<fieldset>
			<div class="row">
				<label for="name" class="col-md-3 col-form-label text-md-right">Place name</label>
				<div class="col-md-8">
					<input type="text" name="name" id="name" required class="form-control valid" minlength="3" maxlength="50" />
				</div>
			</div>
			<br />
			<div class="row">
				<label for="slug" class="col-md-3 col-form-label text-md-right">Place slug</label>
				<div class="col-md-8">
					<input type="text" name="slug" id="slug" required class="form-control valid" minlength="3" maxlength="30" />
				</div>
			</div>
			<small class="grey-text pb-2">Your place will be listed at /place/&lt;your slug&gt;. This cannot be changed. Choose wisely.</small>
			<br />
			<br />
			<div class="row">
				<label for="description" class="col-md-3 col-form-label text-md-right">Description</label>
				<div class="col-md-8">
					<textarea name="description" id="description" required class="form-control valid" maxlength="1000" />
				</div>
			</div>
			<br />
			<button type="submit" class="btn btn-success">Create (<i class="fa fa-gem" /> 10)</button>
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
