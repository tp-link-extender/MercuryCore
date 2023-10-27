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

<Head title="Register" description="Create a Mercury account." />

<div id="wavep" class="w-100 h-100 position-absolute top-0 overflow-hidden">
	<div class="w-100 position-fixed bottom-0">
		<div class="position-absolute" />
		<div class="position-absolute" />
	</div>
</div>

<div class="row">
	<div id="dark" class="col light-text">
		<a type="button" href="/" class="btn btn-lg border-0 px-0 shadow-none">
			<fa fa-arrow-left class="me-2" />
			Home
		</a>
		<h1 class="font-black light-text mb-6">
			Mercury 2 <span class="opacity-50">beta</span>
		</h1>

		<div class="ms-4 mt-4 w-100">
			<h2 class="fs-4 light-text">Original username</h2>
			<p class="light-text opacity-75 more">
				Make sure it is appropriate and between 3-21 characters.
				Underscores are allowed.
			</p>
		</div>
		<div class="ms-4 mt-4 w-100">
			<h2 class="fs-4 light-text">Valid email</h2>
			<p class="light-text opacity-75 more">
				Mercury requires a valid email so you can reset your password at
				any time.
			</p>
		</div>
		<div class="ms-4 mt-4 w-100">
			<h2 class="fs-4 light-text">Secure password</h2>
			<p class="light-text opacity-75 more">
				Make sure your password has a mix of letters, numbers, and
				symbols to protect against hackers.
			</p>
		</div>
	</div>

	<div id="light" class="col col-12 col-lg-6 light-text">
		<div id="login" class="m-auto">
			{#if data.users}
				<h2>Create a free account</h2>
				<p>
					Already have an account?
					<a href="/login" class="text-decoration-none">Log in</a>
				</p>

				<form
					use:enhance
					class="m-auto form-group mt-6"
					method="POST"
					action="?/register">
					<fieldset>
						<label for="username">Username</label>
						<div class="mb-6">
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
							<p class="col-12 mb-4 text-danger">
								{$errors.username || ""}
							</p>
						</div>

						<label for="email">Email Address</label>
						<div class="mb-6">
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
							<p class="col-12 mb-4 text-danger">
								{$errors.email || ""}
							</p>
						</div>

						<label for="password">Password</label>
						<div class="mb-6">
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
							<p class="col-12 mb-4 text-danger">
								{$errors.password || ""}
							</p>
						</div>

						<label for="cpassword">Confirm Password</label>
						<div class="mb-6">
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
							<p class="col-12 mb-4 text-danger">
								{$errors.cpassword || ""}
							</p>
						</div>

						<label for="regkey">Registration Key</label>
						<div class="mb-6">
							<input
								bind:value={$form.regkey}
								{...$constraints.regkey}
								id="regkey"
								name="regkey"
								class="light-text form-control {$errors.regkey
									? 'is-in'
									: ''}valid"
								placeholder="mercurkey-12311121123" />
							<p class="col-12 mb-4 text-danger">
								{$errors.regkey || ""}
							</p>
						</div>

						<button class="container-fluid btn btn-primary mb-4">
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
			{:else}
				<h2 class="light-text">Create the initial account</h2>

				<p class="pt-2">
					This will be the first user account on this Mercury
					instance!
				</p>
				<p>
					It will have all permissions, and will be the destination
					for all transactions that aren't sent to a specific user. It
					will be initialised with a balance of
					<span class="text-success">
						<fa fa-gem />
						999999
					</span>
					, which will not increase or decrease when transactions are made
					to or from the account.
				</p>
				<p>
					Pick the username and password carefully, and good luck on
					your journey with Mercury!
				</p>
				<form
					use:enhance
					class="m-auto form-group mt-6"
					method="POST"
					action="?/initialAccount">
					<fieldset>
						<label for="username">Username</label>
						<div class="mb-6">
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
							<p class="col-12 mb-4 text-danger">
								{$errors.username || ""}
							</p>
						</div>

						<label for="password">Password</label>
						<div class="mb-6">
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
							<p class="col-12 mb-4 text-danger">
								{$errors.password || ""}
							</p>
						</div>

						<label for="cpassword">Confirm Password</label>
						<div class="mb-6">
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
							<p class="col-12 mb-4 text-danger">
								{$errors.cpassword || ""}
							</p>
						</div>

						<button class="container-fluid btn btn-primary mb-4">
							{#if $delayed}
								Working...
							{:else}
								Let's begin!
							{/if}
							<!-- $delayed is true if the form takes
							more than a few hundred ms to submit -->
						</button>
					</fieldset>
				</form>
				<p>
					If you want to create more users, head to the Admin panel
					after logging in to create some registration keys, then head
					back to this page.
				</p>
			{/if}
		</div>
	</div>
</div>

<style lang="stylus">
	@import "../loginregister"

	+lg()
		.col
			padding-top 11vh

	@keyframes waves
		0%
			margin-left -1600px
		100%
			margin-left 0
</style>
