<script lang="ts">
	import { page } from "$app/stores"
	import { superForm } from "sveltekit-superforms/client"

	export let data: import("./$types").PageData

	const { form, errors, message, constraints, enhance, delayed } = superForm(
		data.networkForm,
		{ taintedMessage: false }
	)

	if (data.serverIP) $form.serverIP = data.serverIP
	if (data.serverPort) $form.serverPort = data.serverPort
	if (data.maxPlayers) $form.maxPlayers = data.maxPlayers
</script>

<form use:enhance method="POST" class="col-lg-8" action="?/network&tab=Network">
	<fieldset class="pb-6">
		<div class="row">
			<label for="serverIP" class="col-md-3 text-md-right">Address</label>
			<div class="col-md-9">
				<input
					bind:value={$form.serverIP}
					{...$constraints.serverIP}
					required
					id="serverIP"
					name="serverIP"
					class="form-control {$errors.serverIP
						? 'is-in'
						: ''}valid" />
				<p class="col-12 text-danger">
					{$errors.serverIP || ""}
				</p>
			</div>
		</div>
		<div class="row">
			<label for="serverPort" class="col-md-3 text-md-right">Port</label>
			<div class="col-md-9">
				<input
					bind:value={$form.serverPort}
					{...$constraints.serverPort}
					type="number"
					required
					name="serverPort"
					id="serverPort"
					class="form-control {$errors.serverPort
						? 'is-in'
						: ''}valid" />
				<p class="col-12 text-danger">
					{$errors.serverPort || ""}
				</p>
				<small class="grey-text">
					Using a port number lower than 49152 may not work correctly.
				</small>
			</div>
		</div>
		<div class="row">
			<label for="maxPlayers" class="col-md-3 text-md-right">
				Server Limit
			</label>
			<div class="col-md-9">
				<input
					bind:value={$form.maxPlayers}
					{...$constraints.maxPlayers}
					required
					name="maxPlayers"
					id="maxPlayers"
					type="number"
					class="form-control {$errors.maxPlayers
						? 'is-in'
						: ''}valid" />
				<p class="col-12 text-danger">
					{$errors.maxPlayers || ""}
				</p>
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
