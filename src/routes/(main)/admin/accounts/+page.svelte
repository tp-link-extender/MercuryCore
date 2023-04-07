<script lang="ts">
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
</script>

<svelte:head>
	<title>Admin - Mercury</title>
</svelte:head>

<div class="container py-4">
	<h1 class="light-text mb-0">Admin - Accounts</h1>
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
						href="#resetPassword"
						aria-selected="true"
						role="tab">
						Reset User Password
					</a>
				</li>
			</ul>
		</div>
		<div class="col-lg-10 col-md-9">
			<div id="myTabContent" class="tab-content">
				<div
					class="tab-pane fade active show"
					id="resetPassword"
					role="tabpanel">
					<form use:enhance method="POST" action="?/resetPassword">
						<fieldset>
							<div class="row light-text mb-3">
								<label
									for="username"
									class="col-md-3 col-form-label">
									Username
								</label>
								<div class="col-md-8">
									<input
										bind:value={$form.username}
										{...$constraints.username}
										name="username"
										id="username"
										class="form-control {$errors.username
											? 'is-in'
											: ''}valid" />
									<p class="col-12 mb-3 text-danger">
										{$errors.username || ""}
									</p>
								</div>
							</div>
							<div class="row light-text mb-3">
								<label
									for="password"
									class="col-md-3 col-form-label">
									New password
								</label>
								<div class="col-md-8">
									<input
										bind:value={$form.password}
										{...$constraints.password}
										name="password"
										id="password"
										class="form-control {$errors.password
											? 'is-in'
											: ''}valid" />
									<p class="col-12 mb-3 text-danger">
										{$errors.password || ""}
									</p>
								</div>
							</div>
							<button type="submit" class="btn btn-success">
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
