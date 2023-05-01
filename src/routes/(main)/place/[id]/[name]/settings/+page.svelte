<script lang="ts">
	import { page } from "$app/stores"
	import { superForm } from "sveltekit-superforms/client"
	import fade from "$lib/fade"

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

	let copiedSuccess = false

	if (data.name) $form.title = data.name
	if (data.description[0]) $form.description = data.description[0].text

	if (data.serverIP) $form.serverIP = data.serverIP
	if (data.serverPort) $form.serverPort = data.serverPort
	if (data.maxPlayers) $form.maxPlayers = data.maxPlayers

	if (data.privateServer) $form.privateServer = data.privateServer
</script>

<svelte:head>
	<title>{data.name} Settings - Mercury</title>
</svelte:head>

<div class="container mt-4">
	<h1 class="light-text mb-4">Configure Game</h1>
	<ul class="nav nav-pills mb-3" id="pills-tab">
		<li class="nav-item" role="presentation">
			<button
				class="nav-link active"
				id="pills-view-tab"
				data-bs-toggle="pill"
				data-bs-target="#pills-view"
				type="button"
				role="tab"
				aria-controls="pills-view"
				aria-selected="true">
				<i class="far fa-eye" />
				View
			</button>
		</li>
		<li class="nav-item" role="presentation">
			<button
				class="nav-link"
				id="pills-network-tab"
				data-bs-toggle="pill"
				data-bs-target="#pills-network"
				type="button"
				role="tab"
				aria-controls="pills-network"
				aria-selected="false"
				tabindex={-1}>
				<i class="fas fa-network-wired" />
				Network
			</button>
		</li>
		<li class="nav-item" role="presentation">
			<button
				class="nav-link"
				id="pills-privacy-tab"
				data-bs-toggle="pill"
				data-bs-target="#pills-privacy"
				type="button"
				role="tab"
				aria-controls="pills-privacy"
				aria-selected="false"
				tabindex={-1}>
				<i class="fas fa-eye-low-vision" />
				Privacy
			</button>
		</li>
	</ul>
	<div class="tab-content light-text mt-4" id="pills-tabContent">
		<div
			class="tab-pane fade active show"
			id="pills-view"
			role="tabpanel"
			aria-labelledby="pills-view-tab"
			tabindex={0}>
			<h4 class="light-text fw-normal mb-1">Game View</h4>
			<p class="mb-0 grey-text mb-4">
				Change the title and description of your server.
			</p>
			<form use:enhance class="col-lg-8" method="POST" action="?a=view">
				<fieldset>
					<div class="row mb-2">
						<label
							for="title"
							class="col-md-3 col-form-label text-md-right">
							Title
						</label>
						<div class="col-md-9">
							<input
								bind:value={$form.title}
								{...$constraints.title}
								id="title"
								required
								name="title"
								class="form-control {$errors.title
									? 'is-in'
									: ''}valid" />
							<p class="col-12 mb-3 text-danger">
								{$errors.title || ""}
							</p>
						</div>
					</div>
					<hr class="grey-text" />
					<div class="row">
						<label for="description" class="form-label light-text">
							Description
						</label>
						<div class="container">
							<textarea
								bind:value={$form.description}
								{...$constraints.description}
								required
								placeholder="Maximum 1000 characters"
								id="description"
								name="description"
								rows={3}
								class="form-control light-text mb-1 bg-a {$errors.description
									? 'is-in'
									: ''}valid" />
						</div>
					</div>
				</fieldset>
				<button type="submit" class="btn btn-success mt-4">
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
		</div>

		<div
			class="tab-pane fade"
			id="pills-network"
			role="tabpanel"
			aria-labelledby="pills-network-tab"
			tabindex={0}>
			<h4 class="light-text fw-normal mb-1">Network</h4>
			<p class="mb-0 grey-text mb-4">
				Change the network configurations of your server.
			</p>
			<form use:enhance method="POST" class="col-lg-8" action="?a=ticket">
				<fieldset class="row mb-2">
					<label
						for="ticket"
						class="col-md-3 col-form-label text-md-right">
						Server Ticket
					</label>
					<div class="col-md-9">
						<div class="input-group">
							<input
								id="ticket"
								required
								value={data.serverTicket}
								class="form-control valid"
								disabled />
							<button class="btn btn-primary" type="submit">
								<i class="fas fa-rotate" />
								Regenerate
							</button>
						</div>
						<small class="grey-text">
							The server ticket is required to host servers on
							Mercury. You can regenerate the ticket at any time.
						</small>
					</div>
				</fieldset>
			</form>
			<form
				use:enhance
				class="col-lg-8"
				method="POST"
				action="?a=network">
				<fieldset>
					<div class="row mb-2">
						<label
							for="serverIP"
							class="col-md-3 col-form-label text-md-right">
							Address
						</label>
						<div class="col-md-9">
							<input
								bind:value={$form.serverIP}
								{...$constraints.serverIP}
								id="serverIP"
								required
								name="serverIP"
								class="form-control {$errors.serverIP
									? 'is-in'
									: ''}valid" />
							<p class="col-12 mb-3 text-danger">
								{$errors.serverIP || ""}
							</p>
						</div>
					</div>
					<div class="row mb-2">
						<label
							for="serverPort"
							class="col-md-3 col-form-label text-md-right">
							Port
						</label>
						<div class="col-md-9">
							<input
								bind:value={$form.serverPort}
								{...$constraints.serverPort}
								type="number"
								required
								name="serverPort"
								class="form-control {$errors.serverPort
									? 'is-in'
									: ''}valid" />
							<p class="col-12 mb-3 text-danger">
								{$errors.serverPort || ""}
							</p>
							<small class="grey-text">
								Using a port number lower than 49152 may not
								work correctly.
							</small>
						</div>
					</div>
					<div class="row mb-2">
						<label
							for="maxPlayers"
							class="col-md-3 col-form-label text-md-right">
							Server Limit
						</label>
						<div class="col-md-9">
							<input
								bind:value={$form.maxPlayers}
								{...$constraints.maxPlayers}
								id="maxPlayers"
								type="number"
								required
								name="maxPlayers"
								class="form-control {$errors.maxPlayers
									? 'is-in'
									: ''}valid" />
							<p class="col-12 mb-3 text-danger">
								{$errors.maxPlayers || ""}
							</p>
						</div>
					</div>
					<hr class="grey-text" />
				</fieldset>
				<button type="submit" class="btn btn-success mt-2 mb-2">
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
		</div>

		<div
			class="tab-pane fade"
			id="pills-privacy"
			role="tabpanel"
			aria-labelledby="pills-privacy-tab"
			tabindex={0}>
			<h4 class="light-text fw-normal mb-1">Privacy</h4>
			<p class="mb-0 grey-text mb-4">
				Enable private server to make your game only accessible to those
				with the link.
			</p>
			<form
				use:enhance
				class="col-lg-8"
				method="POST"
				action="?a=privatelink">
				<fieldset class="row mb-2">
					<label
						for="privateLink"
						class="col-md-3 col-form-label text-md-right">
						Private Server Link
					</label>
					<div class="col-md-9">
						<div class="input-group">
							<input
								id="privateLink"
								value={`https://banland.xyz/place/${data.id}/${data.name}?privateServer=${data.privateTicket}`}
								class="form-control valid"
								disabled />
							<button
								on:click={() => {
									navigator.clipboard.writeText(
										`https://banland.xyz/place/${data.id}/${data.name}?privateServer=${data.privateTicket}`
									)

									copiedSuccess = true

									setTimeout(
										() => (copiedSuccess = false),
										4000
									)
								}}
								class="btn btn-info"
								type="button"
								id="button-addon2">
								<i class="fas fa-paste" />
							</button>
							<button
								class="btn btn-primary"
								type="submit"
								id="button-addon2">
								<i class="fas fa-rotate" />
								Regen
							</button>
						</div>
						{#if copiedSuccess}
							<small
								id="copiedSuccess"
								in:fade
								class="text-warning">
								Successfully copied link to clipboard
							</small>
							<br />
						{/if}

						<small class="grey-text">
							This private server link will allow users to join
							your server. Your server (if private) cannot be
							accessed by other players without this link.
						</small>
					</div>
				</fieldset>
			</form>
			<form
				use:enhance
				class="col-lg-8"
				method="POST"
				action="?a=privacy">
				<fieldset>
					<div class="row mb-2">
						<label
							for="privacy"
							class="col-md-3 col-form-label text-md-right">
							Private Server
						</label>
						<div class="col-md-9">
							<input
								bind:checked={$form.privateServer}
								class="form-check-input"
								name="privateServer"
								type="checkbox"
								id="privateServer" />
						</div>
					</div>
					<button type="submit" class="btn btn-success mt-4">
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
				</fieldset>
			</form>
		</div>
	</div>
</div>

<style lang="sass">
	hr
		color: var(--accent)

	.nav-link
		border-radius: 0
		color: var(--light-text)

	.form-control
		color: var(--light-text)

	.nav-pills .active
		background: transparent
		border-style: solid
		border-width: 0px 0px 2px 0px
		border-color: var(--bs-blue)
		color: var(--light-text)

	input[type="checkbox"]
		height: 1.5rem
		width: 1.5rem

	input[type="number"]
		width: 10rem
</style>
