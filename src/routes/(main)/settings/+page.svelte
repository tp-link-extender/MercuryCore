<script lang="ts">
	import { page } from "$app/stores"
	import { superForm } from "sveltekit-superforms/client"

	export let data
	const user = data.user

	const profile = superForm(data.profileForm, {
		taintedMessage: false,
	})
	const password = superForm(data.passwordForm, {
		taintedMessage: false,
	})

	export const snapshot = {
		capture: profile.capture,
		restore: profile.restore,
	}

	// get() moment
	const [
		profileForm,
		profileErrors,
		profileMessage,
		profileConstraints,
		profileDelayed,
	] = [
		profile.form,
		profile.errors,
		profile.message,
		profile.constraints,
		profile.delayed,
	]
	const [
		passwordForm,
		passwordErrors,
		passwordMessage,
		passwordConstraints,
		passwordDelayed,
	] = [
		password.form,
		password.errors,
		password.message,
		password.constraints,
		password.delayed,
	]
</script>

<svelte:head>
	<title>Settings - Mercury</title>
</svelte:head>

<div class="container mt-4">
	<h1 class="light-text mb-4">Settings</h1>
	<ul class="nav nav-pills mb-3" id="pills-tab">
		<li class="nav-item" role="presentation">
			<button
				class="nav-link active"
				id="pills-profile-tab"
				data-bs-toggle="pill"
				data-bs-target="#pills-profile"
				type="button"
				role="tab"
				aria-controls="pills-profile"
				aria-selected="true">
				Profile
			</button>
		</li>
		<li class="nav-item" role="presentation">
			<button
				class="nav-link"
				id="pills-home-tab"
				data-bs-toggle="pill"
				data-bs-target="#pills-home"
				type="button"
				role="tab"
				aria-controls="pills-home"
				aria-selected="false"
				tabindex={-1}>
				Account
			</button>
		</li>
		<li class="nav-item" role="presentation">
			<button
				class="nav-link"
				id="pills-contact-tab"
				data-bs-toggle="pill"
				data-bs-target="#pills-contact"
				type="button"
				role="tab"
				aria-controls="pills-contact"
				aria-selected="false"
				tabindex={-1}>
				Security
			</button>
		</li>
	</ul>
	<div class="tab-content light-text mt-4" id="pills-tabContent">
		<div
			class="tab-pane fade active show"
			id="pills-profile"
			role="tabpanel"
			aria-labelledby="pills-profile-tab"
			tabindex={0}>
			<h4 class="light-text fw-normal mb-1">User Profile</h4>
			<p class="mb-0 grey-text mb-4">
				Change your bio, site theme and more.
			</p>
			<form
				class="col-lg-8"
				method="POST"
				action="?/profile">
				<fieldset>
					<div class="row">
						<label
							for="theme"
							class="col-md-3 col-form-label text-md-right">
							Theme
						</label>
						<div class="col-md-8">
							<select
								bind:value={$profileForm.theme}
								{...$profileConstraints.theme}
								id="theme"
								name="theme"
								class="form-select {$profileErrors.theme
									? 'is-in'
									: ''}valid">
								<option value="standard">Standard</option>
								<option value="darken">Darken</option>
								<option value="storm">Storm</option>
								<option value="solar">Solar</option>
							</select>
							<p class="col-12 mb-3 text-danger">
								{$profileErrors.theme || ""}
							</p>
						</div>
					</div>
					<hr class="grey-text" />
					<div class="row">
						<label for="bio" class="form-label light-text">
							Bio
						</label>
						<div class="container">
							<textarea
								bind:value={$profileForm.bio}
								{...$profileConstraints.bio}
								class="form-control light-text mb-1 bg-a {$profileErrors.bio
									? 'is-in'
									: ''}valid"
								id="bio"
								name="bio"
								rows={3} />
							<small class="grey-text pb-2">
								Maximum 1000 characters, your bio will appear on
								your profile and allow other users to know who
								you are.
							</small>
							<p class="col-12 mb-3 text-danger">
								{$profileErrors.bio || ""}
							</p>
						</div>
					</div>
				</fieldset>
				<button type="submit" class="btn btn-success">
					{#if $profileDelayed}
						Working...
					{:else}
						Save changes
					{/if}
				</button>
			</form>
			<p
				class:text-success={$page.status == 200}
				class:text-danger={$page.status >= 400}>
				{$profileMessage || ""}
			</p>
		</div>
		<div
			class="tab-pane fade"
			id="pills-home"
			role="tabpanel"
			aria-labelledby="pills-home-tab"
			tabindex={0}>
			<h4 class="light-text fw-normal mb-1">User Information</h4>
			<p class="mb-0 grey-text mb-4">
				Information about your account, you can change certain aspects
				of it here.
			</p>
			<div class="form-group row">
				<label for="name" class="col-md-3 col-form-label text-md-right">
					Username
				</label>
				<div class="col-md-9">
					<input
						type="text"
						readonly
						id="name"
						disabled
						value={user?.username}
						class="form-control valid" />
				</div>
				<small class="grey-text pb-2">
					You cannot change your username.
				</small>
			</div>
			<hr />
			<div class="form-group row">
				<label for="name" class="col-md-3 col-form-label text-md-right">
					Email Address
				</label>
				<div class="col-md-9">
					<input
						type="text"
						readonly
						id="email"
						value={`*******@${(user?.email).split("@")[1]}`}
						class="form-control valid" />
				</div>
			</div>
			<h4 class="mt-5 border-top pt-4 light-text">
				Discord Verification
			</h4>
			<p
				class="mb-2
				 ">
				A Discord account has not been linked.
			</p>
			<button type="submit" class="btn btn-primary">
				<i class="fa fa-link" />
				Link Discord
			</button>
			<h4 class="mb-2 mt-3 border-top pt-4 light-text">
				Email Verification
			</h4>
			<p
				class="mb-2
				 ">
				You have not verified your email address.
			</p>
			<button type="submit" class="btn btn-primary mb-3">
				<i class="fa fa-envelope-circle-check" />
				Verify Email
			</button>
		</div>
		<div
			class="tab-pane fade"
			id="pills-contact"
			role="tabpanel"
			aria-labelledby="pills-contact-tab"
			tabindex={0}>
			<h4 class="fw-normal light-text mb-3">Change Password</h4>
			<form
				class="col-sm-8"
				method="POST"
				action="?/password"
				use:password.enhance>
				<fieldset>
					<div class="form-group row gx-0 mb-2">
						<label
							for="password"
							class="col-sm-4 col-form-label pt-0">
							Current Password
						</label>
						<div class="col-sm-10">
							<input
								bind:value={$passwordForm.cpassword}
								{...$passwordConstraints.cpassword}
								type="password"
								class="form-control mb-1 light-text {$passwordErrors.cpassword
									? 'is-in'
									: ''}valid"
								id="cpassword"
								name="cpassword" />
							<p class="col-12 mb-3 text-danger">
								{$passwordErrors.cpassword || ""}
							</p>
						</div>
					</div>
					<div class="form-group row gx-0 mb-2">
						<label
							for="npassword"
							class="col-sm-4 col-form-label pt-0">
							New Password
						</label>
						<div class="col-sm-10">
							<input
								bind:value={$passwordForm.npassword}
								{...$passwordConstraints.npassword}
								type="password"
								class="form-control mb-1 light-text {$passwordErrors.npassword
									? 'is-in'
									: ''}valid"
								id="npassword"
								name="npassword" />
							<small class="grey-text">
								Make sure your password is unique.
							</small>
							<p class="col-12 mb-3 text-danger">
								{$passwordErrors.npassword || ""}
							</p>
						</div>
					</div>
					<div class="form-group row gx-0 mb-2">
						<label
							for="cnpassword"
							class="col-sm-4 col-form-label pt-0">
							Confirm New Password
						</label>
						<div class="col-sm-10">
							<input
								bind:value={$passwordForm.cnpassword}
								{...$passwordConstraints.cnpassword}
								type="password"
								class="form-control mb-1 light-text {$passwordErrors.cnpassword
									? 'is-in'
									: ''}valid"
								id="cnpassword"
								name="cnpassword" />
							<p class="col-12 mb-3 text-danger">
								{$passwordErrors.cnpassword || ""}
							</p>
						</div>
					</div>
				</fieldset>
				<button type="submit" class="btn btn-success">
					{#if $passwordDelayed}
						Working...
					{:else}
						Save changes
					{/if}
				</button>
			</form>
			<p
				class:text-success={$page.status == 200}
				class:text-danger={$page.status >= 400}>
				{$passwordMessage || ""}
			</p>
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
</style>
