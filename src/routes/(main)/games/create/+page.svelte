<script lang="ts">
	import type { ActionData, Snapshot } from "./$types"
	import { enhance } from "$app/forms"

	let fields = {
		name: "",
		slug: "",
		description: "",
<<<<<<< HEAD
		serverIP: "",
		serverPort: "",
		maxPlayers: "",
		privateServer: false,
=======
>>>>>>> main
	}

	export const snapshot: Snapshot = {
		capture: () => fields,
		restore: v => (fields = v),
	}

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
<<<<<<< HEAD
					<input bind:value={fields.name} type="text" name="name" id="name" placeholder="Make sure to make it accurate" required class="form-control valid" minlength="3" maxlength="50" />
				</div>
			</div>
			<div class="row mb-3">
				<label for="description" class="col-md-3 col-form-label text-md-right">Description</label>
				<div class="col-md-8">
					<textarea bind:value={fields.description} name="description" id="description" placeholder="1-1000 characters" required class="form-control valid" minlength="1" maxlength="1000" />
				</div>
			</div>
			<div class="row mb-3">
				<label for="serverIP" class="col-md-3 col-form-label text-md-right">Server IP</label>
				<div class="col-md-8">
					<input bind:value={fields.serverIP} name="serverIP" id="serverIP" placeholder="You can use URLs instead of an IP if you wish" required class="form-control valid" maxlength="1000" />
				</div>
			</div>
			<div class="row mb-3">
				<label for="serverPort" class="col-md-3 col-form-label text-md-right">Server Port</label>
				<div class="col-md-8">
					<input type="number" bind:value={fields.serverPort} name="serverPort" id="serverPort" placeholder="Port ranges 53640 - 65536" required class="form-control valid" min="53640" max="65536" />
				</div>
			</div>
			<div class="row mb-3">
				<label for="maxPlayers" class="col-md-3 col-form-label text-md-right">Server Limit</label>
				<div class="col-md-8">
					<input type="number" bind:value={fields.maxPlayers} name="maxPlayers" id="maxPlayers" placeholder="1 - 99 players" required class="form-control valid" min="1" max="99" />
				</div>
			</div>
			<div class="row mb-3">
				<label for="privateServer" class="col-md-3 col-form-label text-md-right">Private Server</label>
				<div class="col-md-8">
					<input class="form-check-input" type="checkbox"  bind:checked={fields.privateServer} value="privateServer" id="privateServer">
=======
					<input bind:value={fields.name} type="text" name="name" id="name" required class="form-control valid" minlength="3" maxlength="50" />
>>>>>>> main
				</div>
			</div>
			<br />
			<div class="row">
				<label for="slug" class="col-md-3 col-form-label text-md-right">Place slug</label>
				<div class="col-md-8">
					<input bind:value={fields.slug} type="text" name="slug" id="slug" required class="form-control valid" minlength="3" maxlength="30" />
				</div>
			</div>
			<small class="grey-text pb-2">Your place will be listed at /place/&lt;your slug&gt;. This cannot be changed. Choose wisely.</small>
			<br />
			<br />
			<div class="row">
				<label for="description" class="col-md-3 col-form-label text-md-right">Description</label>
				<div class="col-md-8">
					<textarea bind:value={fields.description} name="description" id="description" required class="form-control valid" maxlength="1000" />
				</div>
			</div>
			<br />
			<button type="submit" class="btn btn-success disabled">Create (<i class="fa fa-gem" /> 10)</button>
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
