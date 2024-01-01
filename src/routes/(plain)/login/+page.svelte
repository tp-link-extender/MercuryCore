<script lang="ts">
	import superForm from "$lib/superForm"

	export let data
	const { form, errors, constraints, enhance, delayed, capture, restore } =
		superForm(data.form, {
			onResult: ({ result }) =>
				// Reload to get the new session after redirecting to homepage
				result.type == "redirect" ? window.location.reload() : null,
		})

	export const snapshot = { capture, restore }
</script>

<Head title="Log in" description="Log into your Mercury account." />

<div id="wavep" class="w-full h-full absolute top-0 overflow-hidden">
	<div class="w-full fixed bottom-0">
		<div class="absolute" />
		<div class="absolute" />
	</div>
</div>

<div class="flex <lg:flex-col light-text h-screen overflow-auto">
	<div id="dark" class="lg:w-1/2 p-8vw pt-5vh lg:pt-20vh">
		<a type="button" href="/" class="btn btn-lg border-0 px-0 text-base">
			<fa fa-arrow-left class="pr-2" />
			Home
		</a>
		<h1 class="font-black mb-6">
			Mercury 2 <span class="opacity-50">beta</span>
		</h1>

		<div class="pl-4 w-full">
			<h2 class="light-text">Endless possibilities</h2>
			<p class="light-text opacity-75 more">
				Create or play your favourite games and customise your character
				with items on our catalog.
			</p>
		</div>
		<div class="pl-4 w-full">
			<h2 class="light-text">New features</h2>
			<p class="light-text opacity-75 more">
				In addition to full client usability, additional features such
				as security fixes, QoL fixes and an easy to use website make
				your experience better.
			</p>
		</div>
		<div class="pl-4 w-full">
			<h2 class="light-text">Same nostalgia</h2>
			<p class="light-text opacity-75 more">
				All of our clients will remain as vanilla as possible, to make
				sure it's exactly as you remember it.
			</p>
		</div>
	</div>

	<div id="light" class="lg:w-1/2 p-8vw pt-5vh lg:pt-20vh">
		<div id="login" class="m-auto">
			{#if data.users}
				<h2 class="light-text">Log into your account</h2>
				<p class="light-text">
					Don't yet have an account?
					<a href="/register" class="no-underline">Register</a>
				</p>

				<form use:enhance class="m-auto form-group pt-6" method="POST">
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
								placeholder="Username" />
							<p class="text-danger">
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
								autocomplete="current-password"
								class="light-text form-control {$errors.password
									? 'is-in'
									: ''}valid"
								placeholder="Password" />
							<p class="text-danger">
								{$errors.password || ""}
							</p>
						</div>
						<button class="btn btn-primary mb-4">
							{#if $delayed}
								Working...
							{:else}
								Log in
							{/if}
						</button>
					</fieldset>
				</form>
			{:else}
				<h2>There are no users registered in the database yet!</h2>
				<p class="pt-4">
					Perhaps you've just set up the Mercury 2 source code.
					Perhaps you've already set it up, and something has gone
					terribly wrong with your database.
				</p>
				<p class="pt-2">
					If it's the former, head to the
					<a href="/register" class="no-underline">Register</a>
					page to create the first user!
				</p>
			{/if}
		</div>
	</div>
</div>

<style lang="stylus">
	@import "../loginregister"

	@keyframes waves
		0%
			margin-left 0
		100%
			margin-left -1600px
</style>
