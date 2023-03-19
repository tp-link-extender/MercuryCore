<script lang="ts">
	import { enhance } from "$app/forms"

	export let form
</script>

<svelte:head>
	<title>Admin - Mercury</title>
</svelte:head>

<div class="container py-4">
	<h1 class="light-text mb-0">Admin - Accounts</h1>
	<a href="/admin" class="text-decoration-none">
		<i class="fa-solid fa-caret-left" />
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
							<div class="row light-text">
								<label
									for="username"
									class="col-md-3 col-form-label text-md-right">
									Username
								</label>
								<div class="col-md-8">
									<input
										type="text"
										name="username"
										id="username"
										required
										class="form-control valid" />
								</div>
							</div>
							<br />
							<div class="row light-text">
								<label
									for="password"
									class="col-md-3 col-form-label text-md-right">
									New password
								</label>
								<div class="col-md-8">
									<input
										type="text"
										name="password"
										id="password"
										required
										class="form-control valid" />
								</div>
							</div>
							<br />
							<button type="submit" class="btn btn-success">
								Submit
							</button>
						</fieldset>
					</form>
					<br />
					<p
						class="col-12 mb-3 text-{form?.usersuccess
							? 'success'
							: 'danger'}">
						{form?.msg || ""}
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
