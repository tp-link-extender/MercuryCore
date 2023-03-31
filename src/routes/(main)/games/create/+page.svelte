<script lang="ts">
	import { superForm } from "sveltekit-superforms/client"

	export let data
	const { form, errors, constraints, enhance, delayed, capture, restore } =
		superForm(data.form, {
			taintedMessage: false,
			onResult: async ({ result }) =>
				// Reload to get the new session after redirecting to homepage
				result.type == "redirect" ? window.location.reload() : null,
		})

	export const snapshot = { capture, restore }
	$: other = ($errors as any).other || ""
</script>

<svelte:head>
	<title>Create a place - Mercury</title>
</svelte:head>

<h1 class="text-center light-text">Create a place</h1>

<form use:enhance method="POST" class="container mt-5 light-text">
	<fieldset>
		<div class="row mb-3">
			<label for="name" class="col-md-3 col-form-label">Place name</label>
			<div class="col-md-8">
				<input
					bind:value={$form.name}
					{...$constraints.name}
					name="name"
					id="name"
					placeholder="Make sure to make it accurate"
					class="form-control {$errors.name ? 'is-in' : ''}valid" />
				<p class="col-12 mb-3 text-danger">
					{$errors.name || ""}
				</p>
			</div>
		</div>
		<div class="row mb-3">
			<label for="description" class="col-md-3 col-form-label">
				Description
			</label>
			<div class="col-md-8">
				<textarea
					bind:value={$form.description}
					{...$constraints.description}
					name="description"
					id="description"
					placeholder="1-1000 characters"
					class="form-control {$errors.description
						? 'is-in'
						: ''}valid" />
				<p class="col-12 mb-3 text-danger">
					{$errors.description || ""}
				</p>
			</div>
		</div>
		<div class="row mb-3">
			<label for="serverIP" class="col-md-3 col-form-label">
				Server IP
			</label>
			<div class="col-md-8">
				<input
					bind:value={$form.serverIP}
					{...$constraints.serverIP}
					name="serverIP"
					id="serverIP"
					placeholder="You can use a URL instead of an IP if you wish"
					required
					class="form-control {$errors.serverIP
						? 'is-in'
						: ''}valid" />
				<p class="col-12 mb-3 text-danger">
					{$errors.serverIP || ""}
				</p>
			</div>
		</div>
		<div class="row mb-3">
			<label for="serverPort" class="col-md-3 col-form-label">
				Server Port
			</label>
			<div class="col-md-8">
				<input
					bind:value={$form.serverPort}
					{...$constraints.serverPort}
					type="number"
					name="serverPort"
					id="serverPort"
					placeholder="25565 - 65536"
					class="form-control {$errors.serverPort
						? 'is-in'
						: ''}valid" />
				<p class="col-12 mb-3 text-danger">
					{$errors.serverPort || ""}
				</p>
			</div>
		</div>
		<div class="row mb-3">
			<label for="maxPlayers" class="col-md-3 col-form-label">
				Player Limit
			</label>
			<div class="col-md-8">
				<input
					bind:value={$form.maxPlayers}
					{...$constraints.maxPlayers}
					type="number"
					name="maxPlayers"
					id="maxPlayers"
					placeholder="1 - 99 players"
					class="form-control {$errors.maxPlayers
						? 'is-in'
						: ''}valid" />
				<p class="col-12 mb-3 text-danger">
					{$errors.maxPlayers || ""}
				</p>
			</div>
		</div>
		<div class="row mb-4">
			<label for="privateServer" class="col-md-3 col-form-label">
				Private Server
			</label>
			<div class="col-md-8">
				<input
					bind:checked={$form.privateServer}
					{...$constraints.privateServer}
					class="form-check-input"
					type="checkbox"
					name="privateServer"
					id="privateServer" />
				<p class="col-12 mb-3 text-danger">
					{$errors.privateServer || ""}
				</p>
			</div>
		</div>
		<button type="submit" class="btn btn-success">
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

<style lang="sass">
	@media only screen and (min-width: 576px)
		.container
			width: 50rem
	
	input
		&[type="checkbox"]
			height: 1.5rem
			width: 1.5rem
		&[type="number"]
			width: 9rem
</style>
