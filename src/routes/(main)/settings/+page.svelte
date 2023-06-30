<script lang="ts">
	import { page } from "$app/stores"
	import { superForm } from "sveltekit-superforms/client"
	import { Tab, TabNav, TabData } from "$lib/components/Tabs"

	export let data
	const { user } = data

	// get() moment
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

	if (data.theme) $form.theme = data.theme as typeof $form.theme
	if (data.bio?.[0]) $form.bio = data.bio[0].text

	let tabData = TabData(data.url, ["Profile", "Account", "Security"])
</script>

<svelte:head>
	<title>Settings - Mercury</title>
</svelte:head>

<div class="container mt-4 light-text">
	<h1 class="light-text mb-4">Settings</h1>
	<TabNav bind:tabData />
	<Tab {tabData}>
		<h4 class="light-text fw-normal mb-1">User Profile</h4>
		<p class="mb-0 grey-text mb-4">Change your bio, site theme and more.</p>
		<form class="col-lg-8" method="POST" action="?a=profile">
			<fieldset>
				<div class="row">
					<label
						for="theme"
						class="col-md-3 col-form-label text-md-right">
						Theme
					</label>
					<div class="col-md-8">
						<select
							bind:value={$form.theme}
							{...$constraints.theme}
							id="theme"
							name="theme"
							class="form-select {$errors.theme
								? 'is-in'
								: ''}valid">
							<option value="standard">Standard</option>
							<option value="darken">Darken</option>
							<option value="storm">Storm</option>
							<option value="solar">Solar</option>
						</select>
						<p class="col-12 mb-3 text-danger">
							{$errors.theme || ""}
						</p>
					</div>
				</div>
				<hr class="grey-text" />
				<div class="row">
					<label for="bio" class="form-label light-text">Bio</label>
					<div class="container">
						<textarea
							bind:value={$form.bio}
							{...$constraints.bio}
							class="form-control light-text mb-1 bg-a {$errors.bio
								? 'is-in'
								: ''}valid"
							id="bio"
							name="bio"
							rows={3} />
						<small class="grey-text pb-2">
							Maximum 1000 characters, your bio will appear on
							your profile and allow other users to know who you
							are.
						</small>
						<p class="col-12 mb-3 text-danger">
							{$errors.bio || ""}
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
		</form>
		<p
			class:text-success={$page.status == 200}
			class:text-danger={$page.status >= 400}>
			{$message || ""}
		</p>
	</Tab>

	<Tab {tabData}>
		<h4 class="light-text fw-normal mb-1">User Information</h4>
		<p class="mb-0 grey-text mb-4">
			Information about your account, you can change certain aspects of it
			here.
		</p>
		<div class="form-group row">
			<label for="name" class="col-md-3 col-form-label text-md-right">
				Username
			</label>
			<div class="col-md-6">
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
		<hr class="grey-text" />
		<div class="form-group row mb-5">
			<label for="name" class="col-md-3 col-form-label text-md-right">
				Email Address
			</label>
			<div class="col-md-6">
				<input
					type="text"
					readonly
					id="email"
					value={`*******@${(user?.email).split("@")[1]}`}
					class="form-control valid" />
			</div>
		</div>
		<hr class="grey-text" />
		<h4 class="mb-2 light-text">Discord Verification</h4>
		<p
			class="mb-2
				 ">
			A Discord account has not been linked.
		</p>
		<button class="btn btn-primary">
			<i class="fa fa-link" />
			Link Discord
		</button>
		<hr class="grey-text" />
		<h4 class="mb-2 light-text">Email Verification</h4>
		<p
			class="mb-2
				 ">
			You have not verified your email address.
		</p>
		<button class="btn btn-primary mb-3">
			<i class="fa fa-envelope-circle-check" />
			Verify Email
		</button>
	</Tab>

	<Tab {tabData}>
		<h4 class="fw-normal light-text mb-3">Change Password</h4>
		<form use:enhance class="col-sm-8" method="POST" action="?a=password">
			<fieldset>
				<div class="form-group row gx-0 mb-2">
					<label for="password" class="col-sm-4 col-form-label pt-0">
						Current Password
					</label>
					<div class="col-sm-10">
						<input
							bind:value={$form.cpassword}
							{...$constraints.cpassword}
							type="password"
							autocomplete="current-password"
							class="form-control mb-1 light-text {$errors.cpassword
								? 'is-in'
								: ''}valid"
							id="cpassword"
							name="cpassword" />
						<p class="col-12 mb-3 text-danger">
							{$errors.cpassword || ""}
						</p>
					</div>
				</div>
				<div class="form-group row gx-0 mb-2">
					<label for="npassword" class="col-sm-4 col-form-label pt-0">
						New Password
					</label>
					<div class="col-sm-10">
						<input
							bind:value={$form.npassword}
							{...$constraints.npassword}
							type="password"
							autocomplete="new-password"
							class="form-control mb-1 light-text {$errors.npassword
								? 'is-in'
								: ''}valid"
							id="npassword"
							name="npassword" />
						<small class="grey-text">
							Make sure your password is unique.
						</small>
						<p class="col-12 mb-3 text-danger">
							{$errors.npassword || ""}
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
							bind:value={$form.cnpassword}
							{...$constraints.cnpassword}
							type="password"
							autocomplete="new-password"
							class="form-control mb-1 light-text {$errors.cnpassword
								? 'is-in'
								: ''}valid"
							id="cnpassword"
							name="cnpassword" />
						<p class="col-12 mb-3 text-danger">
							{$errors.cnpassword || ""}
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
		</form>
		<p
			class:text-success={$page.status == 200}
			class:text-danger={$page.status >= 400}>
			{$message || ""}
		</p>
	</Tab>
</div>

<style lang="sass">
	.nav-link
		border-radius: 0
		color: var(--light-text)

	.form-control
		color: var(--light-text)
</style>
