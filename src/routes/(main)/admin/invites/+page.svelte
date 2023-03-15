<script lang="ts">
	import { enhance } from "$app/forms"
	import fade from "$lib/fade"
	
	export let data
	export let form: any

    let customKey = false
    let expiryDate = false

    const tomorrow = new Date(Date.now() + 86400000).toISOString().slice(0, 10)

</script>

<svelte:head>
	<title>Admin - Mercury</title>
</svelte:head>

<div class="container py-4">
	<h1 class="light-text mb-0">Admin - Invites</h1>
	<a href="/admin" class="text-decoration-none"><i class="fa-solid fa-caret-left" /> Back to panel</a>
	<div class="row mt-4">
		<div class="col-lg-2 col-md-3 mb-4">
			<ul class="nav nav-tabs flex-column border-0" role="tablist">
				<li class="nav-item" role="presentation">
					<a class="nav-link active" data-bs-toggle="tab" href="#genKey" aria-selected="true" role="tab">Create Invite Key</a>
				</li>
				<li class="nav-item" role="presentation">
					<a class="nav-link" data-bs-toggle="tab" href="#invites" aria-selected="false" role="tab" tabindex="-1">Invites</a>
				</li>
			</ul>
		</div>
		<div class="col-lg-10 col-md-9">
			<div id="myTabContent" class="tab-content">
				<div class="tab-pane fade active show" id="genKey" role="tabpanel">
					<form use:enhance method="POST">
						<fieldset>
                            <div class="row">
								<label for="enableInviteCustom" class="col-md-3 col-form-label text-md-right light-text">Enable custom invite key</label>
								<div class="col-md-2">
									<input type="checkbox" name="enableInviteCustom" id="enableInviteCustom" bind:checked={customKey} value="true" class="valid form-check-input" />
								</div>
							</div>
                            <br />
                            {#if customKey}
                            <div class="row" transition:fade>
								<label for="inviteCustom" class="col-md-3 col-form-label text-md-right light-text">Custom invite key</label>
								<div class="col-md-8">
									<input type="text" name="inviteCustom" id="inviteCustom" maxlength="50" minlength="3" required class="form-control valid" />
                                    <small class="light-text">Instead of having a randomly generated key, this allows you to set the key.</small>
								</div>
							</div>
							<br />
                            {/if}
                            <div class="row">
								<label for="enableInviteExpiry" class="col-md-3 col-form-label text-md-right light-text">Enable expiry</label>
								<div class="col-md-2">
									<input type="checkbox" name="enableInviteExpiry" id="enableInviteExpiry" bind:checked={expiryDate} value="true" class="valid form-check-input" />
								</div>
							</div>
                            <br />
                            {#if expiryDate}
                            <div class="row" transition:fade>
								<label for="inviteExpiry" class="col-md-3 col-form-label text-md-right light-text">Expiry date</label>
								<div class="col-md-8">
									<input type="date" name="inviteExpiry" id="inviteExpiry" min="{tomorrow}" required class="form-control valid" />
								</div>
							</div>
							<br />
                            {/if}
                            <div class="row">
								<label for="inviteUses" class="col-md-3 col-form-label text-md-right light-text">Uses</label>
								<div class="col-md-8">
									<input type="number" min="1" name="inviteUses" id="inviteUses" required class="form-control valid" />
								</div>
							</div>
							<br />
							<button name="action" value="create" class="btn btn-success">Submit</button>
							<br />
							{#if form?.area == "create"}
								<p class="col-12 mb-3 text-{form?.success ? 'success' : 'danger'}">{form?.msg || ""}</p>
							{/if}
						</fieldset>
					</form>
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
											<input type="hidden" name="id" value={invite.key} />
											<button name="action" value="disable" class="btn btn-sm btn-link text-decoration-none text-danger my-0"><i class="fa-solid fa-ban"/> Disable Invite</button
											>
										</form>
									</td>
									<td>mercurkey-{invite.key}</td>
									<td>{invite.usesLeft}</td>
									<td>{invite.creator?.username}</td>
									<td>{new Date(invite.creation).toLocaleDateString()}</td>
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
</style>
