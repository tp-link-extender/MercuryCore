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
	<meta name="description" content="Log into your Mercury account." />
	<title>Log in - Mercury</title>
</svelte:head>

<div id="wavep" class="w-100 h-100 absolute top-0 overflow-hidden">
	<div class="w-100 fixed bottom-0">
		<div class="absolute" />
		<div class="absolute" />
	</div>
</div>

<div class="grid grid-cols-12 gap-6">
	<div id="dark" class="col light-text">
		<a type="button" href="/" class="btn btn-lg border-0 px-0 shadow-none">
			<i class="fa fa-arrow-left me-2" />
			Home
		</a>
		<h1 class="font-bold light-text mb-4">
			Mercury 2 <span class="opacity-50">beta</span>
		</h1>

		<div class="ms-3 mt-3 w-100">
			<h2 class="h4 light-text">Endless possibilities</h2>
			<p class="light-text opacity-75 more">
				Create or play your favourite games and customise your character
				with items on our catalog.
			</p>
		</div>
		<div class="ms-3 mt-3 w-100">
			<h2 class="h4 light-text">New features</h2>
			<p class="light-text opacity-75 more">
				In addition to full client usability, additional features such
				as security fixes, QoL fixes and an easy to use website make
				your experience better.
			</p>
		</div>
		<div class="ms-3 mt-3 w-100">
			<h2 class="h4 light-text">Same nostalgia</h2>
			<p class="light-text opacity-75 more">
				All of our clients will remain as vanilla as possible, to make
				sure it's exactly as you remember it.
			</p>
		</div>
	</div>

	<div id="light" class="col col-span-12 lg:col-span-6 light-text">
		<div id="login" class="m-auto">
			<h2 class="light-text">Log into your account</h2>
			<p class="light-text">
				Don't yet have an account?
				<a href="/register" class="no-underline">Register</a>
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
							placeholder="Username" />
						<p class="col-span-12 mb-3 text-red-500">
							{$errors.username || ""}
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
							autocomplete="current-password"
							class="light-text form-control {$errors.password
								? 'is-in'
								: ''}valid"
							placeholder="Password" />
						<p class="col-span-12 mb-3 text-red-500">
							{$errors.password || ""}
						</p>
					</div>
					<button
						class="px-5 btn bg-blue-600 hover:bg-blue-800 text-white mb-3">
						{$delayed ? "Working..." : "Log in"}
						<!-- $delayed is true if the form takes 
							more than a few hundred ms to submit -->
					</button>
				</fieldset>
			</form>
		</div>
	</div>
</div>

<style lang="sass">
	@use "../loginregister.sass"

	@keyframes waves
		0%
			margin-left: 0
		100%
			margin-left: -1600px
</style>
