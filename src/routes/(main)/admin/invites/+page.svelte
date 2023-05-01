<script lang="ts">
	import fade from "$lib/fade"
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

	const tomorrow = new Date(Date.now() + 86400000).toISOString().slice(0, 10)
</script>

<svelte:head>
	<title>Admin - Mercury</title>
</svelte:head>

<div class="container py-4">
	<h1 class="light-text mb-0">Admin - Invites</h1>
	<a href="/admin" class="text-decoration-none">
		<i class="fas fa-caret-left" />
		Back to panel
	</a>
	<div class="row mt-4">
		<div class="col-lg-2 col-md-3 mb-4">
			<ul class="nav nav-tabs flex-column border-0">
				<li class="nav-item" role="presentation">
					<a
						class="nav-link active"
						data-bs-toggle="tab"
						href="#genKey"
						aria-selected="true"
						role="tab">
						Create Invite Key
					</a>
				</li>
				<li class="nav-item" role="presentation">
					<a
						class="nav-link"
						data-bs-toggle="tab"
						href="#invites"
						aria-selected="false"
						role="tab"
						tabindex="-1">
						Invites
					</a>
				</li>
			</ul>
		</div>
		<div class="col-lg-10 col-md-9">
			<div id="myTabContent" class="tab-content">
				<div
					class="tab-pane fade active show"
					id="genKey"
					role="tabpanel">
					<form use:enhance method="POST">
						<fieldset>
							<div class="row">
								<label
									for="enableInviteCustom"
									class="col-md-3 col-form-label text-md-right light-text">
									Enable custom invite key
								</label>
								<div class="col-md-2">
									<input
										bind:checked={$form.enableInviteCustom}
										{...$constraints.enableInviteCustom}
										type="checkbox"
										name="enableInviteCustom"
										id="enableInviteCustom"
										value="true"
										class="form-check-input valid" />
								</div>
							</div>
							<br />
							{#if $form.enableInviteCustom}
								<div class="row" transition:fade>
									<label
										for="inviteCustom"
										class="col-md-3 col-form-label text-md-right light-text">
										Custom invite key
									</label>
									<div class="col-md-8">
										<input
											bind:value={$form.inviteCustom}
											{...$constraints.inviteCustom}
											type="text"
											name="inviteCustom"
											id="inviteCustom"
											class="form-control {$errors.inviteCustom
												? 'is-in'
												: ''}valid" />
										<small class="light-text">
											Instead of having a randomly
											generated key, this allows you to
											set the key.
										</small>
										<p class="col-12 mb-3 text-danger">
											{$errors.inviteCustom || ""}
										</p>
									</div>
								</div>
								<br />
							{/if}
							<div class="row">
								<label
									for="enableInviteExpiry"
									class="col-md-3 col-form-label text-md-right light-text">
									Enable expiry
								</label>
								<div class="col-md-2">
									<input
										bind:checked={$form.enableInviteExpiry}
										{...$constraints.enableInviteExpiry}
										type="checkbox"
										name="enableInviteExpiry"
										id="enableInviteExpiry"
										value="true"
										class="form-check-input valid" />
								</div>
							</div>
							<br />
							{#if $form.enableInviteExpiry}
								<div class="row" transition:fade>
									<label
										for="inviteExpiry"
										class="col-md-3 col-form-label text-md-right light-text">
										Expiry date
									</label>
									<div class="col-md-8">
										<input
											bind:value={$form.inviteExpiry}
											{...$constraints.inviteExpiry}
											type="date"
											name="inviteExpiry"
											id="inviteExpiry"
											min={tomorrow}
											required
											class="form-control {$errors.inviteExpiry
												? 'is-in'
												: ''}valid" />
										<p class="col-12 mb-3 text-danger">
											{$errors.inviteExpiry || ""}
										</p>
									</div>
								</div>
								<br />
							{/if}
							<div class="row">
								<label
									for="inviteUses"
									class="col-md-3 col-form-label text-md-right light-text">
									Uses
								</label>
								<div class="col-md-8">
									<input
										bind:value={$form.inviteUses}
										{...$constraints.inviteUses}
										type="number"
										name="inviteUses"
										id="inviteUses"
										class="form-control {$errors.inviteUses
											? 'is-in'
											: ''}valid" />
									<p class="col-12 mb-3 text-danger">
										{$errors.inviteUses || ""}
									</p>
								</div>
							</div>
							<button
								name="action"
								value="create"
								class="btn btn-success mt-3">
								{#if $delayed}
									Working...
								{:else}
									Create
								{/if}
							</button>
						</fieldset>
					</form>
					<p
						class:text-success={$page.status == 200}
						class:text-danger={$page.status >= 400}>
						{$message || ""}
					</p>
				</div>
				<div class="tab-pane fade" id="invites" role="tabpanel">
					<table class="table table-responsive">
						<thead class="light-text">
							<tr>
								<th scope="col">Options</th>
								<th scope="col">Invite</th>
								<th scope="col">Uses Left</th>
								<th scope="col">Creator</th>
								<th scope="col">Creation Date</th>
							</tr>
						</thead>
						<tbody class="light-text">
							{#each data.invites as invite}
								<tr>
									<td>
										<form use:enhance method="POST">
											<input
												type="hidden"
												name="id"
												value={invite.key} />
											<button
												name="action"
												value="disable"
												class="btn btn-sm btn-link text-decoration-none text-danger my-0">
												<i class="fas fa-ban" />
												Disable Invite
											</button>
										</form>
									</td>
									<td>mercurkey-{invite.key}</td>
									<td>{invite.usesLeft}</td>
									<td>{invite.creator?.username}</td>
									<td>
										{new Date(
											invite.creation
										).toLocaleDateString()}
									</td>
								</tr>
							{/each}
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>

<style lang="sass">
	.nav-tabs .nav-item.show .nav-link,
	.nav-tabs .nav-link.active 
		color: rgb(255, 255, 255)
		background-color: rgb(13, 109, 252)
		border-color: var(--bs-nav-tabs-link-active-border-color)
		border-radius: 0.375rem

	.nav-tabs .nav-link 
		margin-bottom: calc(0 * var(--bs-nav-tabs-border-width))
		background: 0 0
		border: var(--bs-nav-tabs-border-width) solid transparent
		border-radius: 0.375rem

	.nav-link
		border-radius: 0
		color: var(--light-text)

	input[type="checkbox"]
		height: 1.5rem
		width: 1.5rem

	input[type="number"]
		width: 10rem
</style>
