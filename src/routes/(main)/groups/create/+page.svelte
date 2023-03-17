<script lang="ts">
	import { enhance } from "$app/forms"

	let fields = {
		name: "",
	}

	export const snapshot = {
		capture: () => fields,
		restore: v => (fields = v),
	}

	export let form
</script>

<svelte:head>
	<title>Create a group - Mercury</title>
</svelte:head>

<h1 class="text-center light-text">Create a group</h1>

<div class="container mt-5 light-text">
	<form use:enhance method="POST">
		<fieldset>
			<div class="row">
				<label for="name" class="col-md-3 col-form-label text-md-right">
					Group name
				</label>
				<div class="col-md-8">
					<input
						bind:value={fields.name}
						type="text"
						name="name"
						id="name"
						required
						class="form-control valid"
						minlength="3"
						maxlength="40" />
				</div>
			</div>
			<small class="grey-text pb-2">
				This cannot be changed. Choose wisely.
			</small>
			<br />
			<br />
			<button type="submit" class="btn btn-success">
				Create (
				<i class="fa fa-gem" />
				10)
			</button>
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
