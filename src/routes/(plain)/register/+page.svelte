<script lang="ts">
	import { superForm } from "sveltekit-superforms/client"

	export let data
	const { form, errors, constraints, enhance, delayed, capture, restore } =
		superForm(data.form, {
			taintedMessage: false,
			onResult: ({ result }) =>
				// Reload to get the new session after redirecting to homepage
				result.type == "redirect" ? window.location.reload() : null,
		})

	export const snapshot = { capture, restore }
</script>

<svelte:head>
	<meta name="description" content="Create a Mercury account." />
	<title>Register - Mercury</title>
</svelte:head>

<div id="wavep" class="w-100 h-100 position-absolute top-0 overflow-hidden">
	<div class="w-100 position-fixed bottom-0">
		<div class="position-absolute" />
		<div class="position-absolute" />
	</div>
</div>

<div class="row">
	<div id="dark" class="col light-text">
		<a type="button" href="/" class="btn btn-lg border-0 px-0 shadow-none">
			<i class="fa fa-arrow-left me-2" />
			Home
		</a>
		<h1 class="fw-bolder light-text mb-4">
			Mercury 2 <span class="opacity-50">beta</span>
		</h1>

		<div class="ms-3 mt-3 w-100">
			<h2 class="h4 light-text">Original username</h2>
			<p class="light-text opacity-75 more">
				Make sure it is appropriate and between 3-21 characters.
				Underscores are allowed.
			</p>
		</div>
		<div class="ms-3 mt-3 w-100">
			<h2 class="h4 light-text">Valid email</h2>
			<p class="light-text opacity-75 more">
				Mercury requires a valid email so you can reset your password at
				any time.
			</p>
		</div>
		<div class="ms-3 mt-3 w-100">
			<h2 class="h4 light-text">Secure password</h2>
			<p class="light-text opacity-75 more">
				Make sure your password has a mix of letters, numbers, and
				symbols to protect against hackers.
			</p>
		</div>
	</div>

	<div id="light" class="col col-12 col-lg-6 light-text">
		<div id="login" class="m-auto">
			<h2 class="light-text">Create a free account</h2>
			<p class="light-text">
				Already have an account?
				<a href="/login" class="text-decoration-none">Log in</a>
			</p>

			<form use:enhance class="m-auto form-group mt-4" method="POST">
				<fieldset>
					<label for="username" class="form-label">Username</label>
					<div class="mb-4">
						<input
							bind:value={$form.username}
							{...$constraints.username}
							id="username"
							name="username"
							autocomplete="username"
							class="light-text form-control {$errors.username
								? 'is-in'
								: ''}valid"
							placeholder="3-21 characters" />
						<p class="col-12 mb-3 text-danger">
							{$errors.username || ""}
						</p>
					</div>

					<label for="email" class="form-label">Email Address</label>
					<div class="mb-4">
						<input
							bind:value={$form.email}
							{...$constraints.email}
							type="email"
							id="email"
							name="email"
							autocomplete="email"
							class="light-text form-control {$errors.email
								? 'is-in'
								: ''}valid"
							placeholder="mercury@banland.xyz" />
						<p class="col-12 mb-3 text-danger">
							{$errors.email || ""}
						</p>
					</div>

					<label for="password" class="form-label">Password</label>
					<div class="mb-4">
						<input
							bind:value={$form.password}
							{...$constraints.password}
							type="password"
							id="password"
							name="password"
							autocomplete="new-password"
							class="light-text form-control {$errors.password
								? 'is-in'
								: ''}valid"
							placeholder="Password" />
						<p class="col-12 mb-3 text-danger">
							{$errors.password || ""}
						</p>
					</div>

					<label for="cpassword" class="form-label">
						Confirm Password
					</label>
					<div class="mb-4">
						<input
							bind:value={$form.cpassword}
							{...$constraints.cpassword}
							type="password"
							id="cpassword"
							name="cpassword"
							autocomplete="new-password"
							class="light-text form-control {$errors.cpassword
								? 'is-in'
								: ''}valid"
							placeholder="Confirm Password" />
						<p class="col-12 mb-3 text-danger">
							{$errors.cpassword || ""}
						</p>
					</div>

					<label for="regkey" class="form-label">
						Registration Key
					</label>
					<div class="mb-4">
						<input
							bind:value={$form.regkey}
							{...$constraints.regkey}
							id="regkey"
							name="regkey"
							class="light-text form-control {$errors.regkey
								? 'is-in'
								: ''}valid"
							placeholder="mercurkey-12311121123" />
						<p class="col-12 mb-3 text-danger">
							{$errors.regkey || ""}
						</p>
					</div>

					<button class="container-fluid btn btn-primary mb-3">
						{#if $delayed}
							Working...
						{:else}
							Register
						{/if}
						<!-- $delayed is true if the form takes 
							more than a few hundred ms to submit -->
					</button>
				</fieldset>
			</form>
			<p>
				By signing up, you agree to our
				<a href="/terms" class="text-decoration-none">
					Terms of Service
				</a>
				and
				<a href="/privacy" class="text-decoration-none">
					Privacy policy
				</a>
				.
			</p>
		</div>
	</div>
</div>

<style lang="stylus">
	@import "../loginregister"

	@media (min-width 992px)
		.col
			padding-top 11vh

	@keyframes waves
		0%
			margin-left -1600px
		100%
			margin-left 0
</style>
