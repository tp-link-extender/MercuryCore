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

<Head title="Log in" description="Log into your Mercury account." />

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
		<h1 class="font-black light-text mb-6">
			Mercury 2 <span class="opacity-50">beta</span>
		</h1>

		<div class="ms-4 mt-4 w-100">
			<h2 class="fs-4 light-text">Endless possibilities</h2>
			<p class="light-text opacity-75 more">
				Create or play your favourite games and customise your character
				with items on our catalog.
			</p>
		</div>
		<div class="ms-4 mt-4 w-100">
			<h2 class="fs-4 light-text">New features</h2>
			<p class="light-text opacity-75 more">
				In addition to full client usability, additional features such
				as security fixes, QoL fixes and an easy to use website make
				your experience better.
			</p>
		</div>
		<div class="ms-4 mt-4 w-100">
			<h2 class="fs-4 light-text">Same nostalgia</h2>
			<p class="light-text opacity-75 more">
				All of our clients will remain as vanilla as possible, to make
				sure it's exactly as you remember it.
			</p>
		</div>
	</div>

	<div id="light" class="col col-12 col-lg-6 light-text">
		<div id="login" class="m-auto">
			<h2 class="light-text">Log into your account</h2>
			<p class="light-text">
				Don't yet have an account?
				<a href="/register" class="text-decoration-none">Register</a>
			</p>

			<form use:enhance class="m-auto form-group mt-6" method="POST">
				<fieldset>
					<label for="username" class="form-label">Username</label>
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
							placeholder="Username" />
						<p class="col-12 mb-4 text-danger">
							{$errors.username || ""}
						</p>
					</div>

					<label for="password" class="form-label">Password</label>
					<div class="mb-6">
						<input
							bind:value={$form.password}
							{...$constraints.password}
							type="password"
							id="password"
							name="password"
							autocomplete="current-password"
							class="light-text form-control {$errors.password
								? 'is-in'
								: ''}valid"
							placeholder="Password" />
						<p class="col-12 mb-4 text-danger">
							{$errors.password || ""}
						</p>
					</div>
					<button class="container-fluid btn btn-primary mb-4">
						{#if $delayed}
							Working...
						{:else}
							Log in
						{/if}
						<!-- $delayed is true if the form takes
							more than a few hundred ms to submit -->
					</button>
				</fieldset>
			</form>
		</div>
	</div>
</div>

<style lang="stylus">
	@import "../loginregister"

	+lg()
		.col
			padding-top 20vh

	@keyframes waves
		0%
			margin-left 0
		100%
			margin-left -1600px
</style>
