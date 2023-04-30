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
	<h1 class="light-text mb-0">Admin - Moderate User</h1>
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
						href="#moderateUser"
						aria-selected="true"
						role="tab">
						Moderate User
					</a>
				</li>
			</ul>
		</div>
		<div class="col-lg-10 col-md-9">
			<div id="myTabContent" class="tab-content">
				<div
					class="tab-pane fade active show"
					id="moderateUser"
					role="tabpanel">
					<form use:enhance method="POST" action="?/moderateUser">
						<fieldset>
							<div class="row">
								<label
									for="username"
									class="col-md-3 col-form-label light-text">
									Username
								</label>
								<div class="col-md-8">
									<input
										bind:value={$form.username}
										{...$constraints.username}
										type="text"
										name="username"
										id="username"
										class="form-control {$errors.username
											? 'is-in'
											: ''}valid" />
									<p class="col-12 text-danger">
										{$errors.username || ""}
									</p>
								</div>
							</div>
							<div class="row">
								<label
									for="action"
									class="col-md-3 col-form-label light-text">
									Action
								</label>
								<div class="col-md-8">
									<select
										bind:value={$form.action}
										{...$constraints.action}
										name="action"
										id="action"
										class="form-control light-text {$errors.action
											? 'is-in'
											: ''}valid">
										<option value="1" selected>
											Warning
										</option>
										<option value="2">Ban</option>
										<option value="3">Termination</option>
										<option value="4">
											Account Deletion
										</option>
										<option value="5">Unban</option>
									</select>
									<p class="col-12 text-danger">
										{$errors.action || ""}
									</p>
								</div>
							</div>
							{#if $form.action == 2}
								<div class="row" transition:fade>
									<label
										for="banDate"
										class="col-md-3 col-form-label light-text">
										Ban until
									</label>
									<div class="col-md-8">
										<input
											bind:value={$form.banDate}
											{...$constraints.banDate}
											type="date"
											name="banDate"
											id="banDate"
											min={tomorrow}
											required
											class="form-control {$errors.banDate
												? 'is-in'
												: ''}valid" />
										<p class="col-12 text-danger">
											{$errors.banDate || ""}
										</p>
									</div>
								</div>
							{/if}
							<div class="row">
								<label
									for="reason"
									class="col-md-3 col-form-label light-text">
									Reason
								</label>
								<div class="col-md-8">
									<textarea
										bind:value={$form.reason}
										{...$constraints.reason}
										name="reason"
										id="reason"
										class="form-control {$errors.reason
											? 'is-in'
											: ''}valid" />
									<p class="col-12 text-danger">
										{$errors.reason || ""}
									</p>
								</div>
							</div>
							<button type="submit" class="btn btn-success mt-3">
								{#if $delayed}
									Working...
								{:else}
									Submit
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
</style>
