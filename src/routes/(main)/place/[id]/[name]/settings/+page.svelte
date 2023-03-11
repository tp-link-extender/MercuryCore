<script lang="ts">
	import { enhance } from "$app/forms"
	import fade from "$lib/fade"

	export let form
	export let data

	let copiedSuccess = false
	let copiedSuccessMsg: any

	function copyPrivateLink() {
		copiedSuccess = false

		navigator.clipboard.writeText(`https://banland.xyz/place/${data.id}/${data.name}?privateServer=${data.privateTicket}`)

		copiedSuccess = true

		setTimeout(() => (copiedSuccess = false), 4000)
	}
</script>

<svelte:head>
	<title>{data.name} Settings - Mercury</title>
</svelte:head>

<div class="container mt-4">
	<h1 class="light-text mb-4">Configure Game</h1>
	<ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">
		<li class="nav-item" role="presentation">
			<button class="nav-link active" id="pills-view-tab" data-bs-toggle="pill" data-bs-target="#pills-view" type="button" role="tab" aria-controls="pills-view" aria-selected="true"
				><i class="fa-regular fa-eye" /> View</button
			>
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
				tabindex={-1}><i class="fa-solid fa-network-wired" /> Network</button
			>
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
				tabindex={-1}><i class="fa-solid fa-eye-low-vision" /> Privacy</button
			>
		</li>
	</ul>
	<div class="tab-content light-text mt-4" id="pills-tabContent">
		<div class="tab-pane fade active show" id="pills-view" role="tabpanel" aria-labelledby="pills-view-tab" tabindex={0}>
			<h4 class="light-text fw-normal mb-1">Game View</h4>
			<p class="mb-0 grey-text mb-4">Change the title and description of your server.</p>
			<form class="col-lg-8" method="POST" use:enhance>
				<input type="hidden" name="action" value="view" />
				<fieldset>
					<div class="row mb-2">
						<label for="title" class="col-md-3 col-form-label text-md-right">Title</label>
						<div class="col-md-9">
							<input id="title" required name="title" value={form?.title || data.name} class="form-control {form?.area == 'title' ? 'is-invalid' : 'valid'}" />
							{#if form?.area == "title"}
								<small class="col-12 mb-3 text-danger">{form?.msg}</small>
							{/if}
						</div>
					</div>
					<hr class="grey-text" />
					<div class="row">
						<label for="desc" class="form-label light-text">Description</label>
						<div class="container">
							<textarea
								required
								class="form-control light-text mb-1 {form?.area == 'desc' ? 'is-invalid' : 'valid'}"
								placeholder="Maximum 1000 characters"
								id="desc"
								name="desc"
								rows={3}
								value={form?.description?.toString() || data.description}
							/>
						</div>
					</div>
				</fieldset>
				<button type="submit" class="btn btn-success mt-4">Save Changes</button>
				{#if form?.viewsuccess}
					<p class="text-success mt-3">Game view changed successfully!</p>
				{/if}
			</form>
		</div>

		<div class="tab-pane fade" id="pills-network" role="tabpanel" aria-labelledby="pills-network-tab" tabindex={0}>
			<h4 class="light-text fw-normal mb-1">Network</h4>
			<p class="mb-0 grey-text mb-4">Change the network configurations of your server.</p>
			<form method="POST" class="col-lg-8" use:enhance>
				<input type="hidden" name="action" value="ticket" />
				<fieldset class="row mb-2">
					<label for="ticket" class="col-md-3 col-form-label text-md-right">Server Ticket</label>
					<div class="col-md-9">
						<div class="input-group">
							<input id="ticket" required value={form?.serverTicket || data.serverTicket} class="form-control valid" disabled />
							{#if form?.area == "ticket"}
								<small class="col-12 mb-3 text-danger">{form?.msg}</small>
							{/if}
							<button class="btn btn-primary" type="submit"><i class="fa-solid fa-rotate" /> Regenerate</button>
						</div>
						{#if form?.ticketregensuccess}
							<small in:fade class="text-success">Successfully regenerated server ticket</small><br />
						{/if}
						<small class="grey-text"> The server ticket is required to host servers on Mercury. You can regenerate the ticket at any time. </small>
					</div>
				</fieldset>
			</form>
			<form class="col-lg-8" method="POST" use:enhance>
				<input type="hidden" name="action" value="network" />
				<fieldset>
					<div class="row mb-2">
						<label for="address" class="col-md-3 col-form-label text-md-right">Address</label>
						<div class="col-md-9">
							<input id="address" required name="address" value={form?.serverIP || data.serverIP} class="form-control {form?.area == 'address' ? 'is-invalid' : 'valid'}" />
							{#if form?.area == "address"}
								<small class="col-12 mb-3 text-danger">{form?.msg}</small>
							{/if}
						</div>
					</div>
					<div class="row mb-2">
						<label for="port" class="col-md-3 col-form-label text-md-right">Port</label>
						<div class="col-md-9">
							<input
								id="port"
								type="number"
								min="1024"
								max="65535"
								required
								name="port"
								value={form?.serverPort || data.serverPort}
								class="form-control {form?.area == 'port' ? 'is-invalid' : 'valid'}"
							/>
							{#if form?.area == "port"}
								<small class="col-12 mb-3 text-danger">{form?.msg}</small>
							{/if}
							<small class="grey-text">Using a port number lower than 49152 may not work correctly.</small>
						</div>
					</div>
					<div class="row mb-2">
						<label for="serverLimit" class="col-md-3 col-form-label text-md-right">Server Limit</label>
						<div class="col-md-9">
							<input
								id="serverLimit"
								type="number"
								min="1"
								max="100"
								required
								name="serverLimit"
								value={form?.maxPlayers || data.maxPlayers}
								class="form-control {form?.area == 'maxPlayers' ? 'is-invalid' : 'valid'}"
							/>
							{#if form?.area == "maxPlayers"}
								<small class="col-12 mb-3 text-danger">{form?.msg}</small>
							{/if}
						</div>
					</div>
					<hr class="grey-text" />
				</fieldset>
				<button type="submit" class="btn btn-success mt-2 mb-2">Save Changes</button>
				{#if form?.networksuccess}
					<p class="text-success mt-3">Network settings changed successfully!</p>
				{/if}
			</form>
		</div>

		<div class="tab-pane fade" id="pills-privacy" role="tabpanel" aria-labelledby="pills-privacy-tab" tabindex={0}>
			<h4 class="light-text fw-normal mb-1">Privacy</h4>
			<p class="mb-0 grey-text mb-4">Enable private server to make your game only accessible to those with the link.</p>
			<form class="col-lg-8" method="POST" use:enhance>
				<input type="hidden" name="action" value="privatelink" />
				<fieldset class="row mb-2">
					<label for="privateLink" class="col-md-3 col-form-label text-md-right">Private Server Link</label>
					<div class="col-md-9">
						<div class="input-group">
							<input id="privateLink" value={`https://banland.xyz/place/${data.id}/${data.name}?privateServer=${data.privateTicket}`} class="form-control valid" disabled />
							{#if form?.area == "privacy"}
								<small class="col-12 mb-3 text-danger">{form?.msg}</small>
							{/if}
							<button on:click={copyPrivateLink} class="btn btn-info" type="button" id="button-addon2"><i class="fa-solid fa-paste" /></button>
							<button class="btn btn-primary" type="submit" id="button-addon2"><i class="fa-solid fa-rotate" /> Regen</button>
						</div>
						{#if form?.privateregensuccess}
							<small in:fade class="text-success">Successfully regenerated private link</small><br />
						{/if}
						{#if copiedSuccess}
							<small id="copiedSuccess" in:fade bind:this={copiedSuccessMsg} class="text-warning">Successfully copied link to clipboard</small><br />
						{/if}

						<small class="grey-text"> This private server link will allow users to join your server. Your server (if private) cannot be accessed by other players without this link.</small>
					</div>
				</fieldset>
			</form>
			<form class="col-lg-8" method="POST" use:enhance>
				<input type="hidden" name="action" value="privacy" />
				<fieldset>
					<div class="row mb-2">
						<label for="privacy" class="col-md-3 col-form-label text-md-right">Private Server</label>
						<div class="col-md-9">
							<input class="form-check-input" name="privacy" type="checkbox" id="privacy" checked={!!(form?.privateServer || data.privateServer)} />
						</div>
					</div>
					<button type="submit" class="btn btn-success mt-4">Save Changes</button>
					{#if form?.privatesuccess}
						<p class="text-success mt-3">Game privacy changed successfully!</p>
					{/if}
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
	
	textarea
		background: var(--accent)
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
</style>
