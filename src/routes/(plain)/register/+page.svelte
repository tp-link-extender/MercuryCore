<script lang="ts">
	import { applyAction, enhance } from "$app/forms"

	let username, email, password, cpassword, regkey

	const things = [
		["Original username", "Make sure it is appropriate and between 3-21 characters. Underscores are allowed."],
		["Valid email", "Mercury requires a valid email so you can reset your password at any time."],
		["Secure password", "Make sure your password has a mix of letters, numbers, and symbols to protect against hackers."],
	]

	export let form: any
</script>

<svelte:head>
	<title>Register - Mercury</title>
</svelte:head>

<div id="wavep" class="w-100 h-100 position-absolute top-0 overflow-hidden">
	<div class="w-100 position-fixed bottom-0 z-1">
		<div class="position-absolute" />
		<div class="position-absolute" />
	</div>
</div>

<div class="row">
	<div class="col light-text z-0" id="dark">
		<a type="button" href="/" class="btn btn-lg border-0 px-0"><i class="fa-solid fa-arrow-left me-2" /> Home</a>
		<h1 class="fw-bolder light-text mb-4">Mercury 2 <span class="opacity-50">beta</span></h1>
		{#each things as [thing, more]}
			<div class="thing d-flex flex-row mt-3">
				<div class="ms-3 w-100">
					<p class="h4 light-text">{thing}</p>
					<p class="light-text opacity-75 more">{more}</p>
				</div>
			</div>
		{/each}
	</div>

	<div id="light" class="col col-12 col-lg-6 light-text z-1">
		<div id="login" class="m-auto">
			<h2 class="light-text">Create a free account</h2>
			<p class="light-text">
				Already have an account?
				<a href="/login" class="text-decoration-none">Log in</a>
			</p>

			<form
				class="m-auto form-group mt-4"
				method="POST"
				use:enhance={() => {
					return async ({ result }) => {
						console.log(result)
						if (result.type != "failure") window.location.reload()
						else await applyAction(result)
					}
				}}
			>
				<!-- use:enhance function prevents lucia getUser() still being undefined after login -->
				<fieldset>
					<label for="username" class="form-label">Username</label>
					<div class="mb-4">
						<input id="username" name="username" type="text" class="light-text form-control {form?.area == 'username' ? 'is-invalid' : 'valid'}" placeholder="3-21 characters" />
						{#if form?.area == "username"}
							<small class="col-12 mb-3 text-danger">{form.msg}</small>
						{/if}
					</div>

					<label for="email" class="form-label">Email Address</label>
					<div class="mb-4">
						<input id="email" name="email" type="email" class="light-text form-control {form?.area == 'email' ? 'is-invalid' : 'valid'}" placeholder="mercury@banland.xyz" />
						{#if form?.area == "email"}
							<small class="col-12 mb-3 text-danger">{form.msg}</small>
						{/if}
					</div>

					<label for="password" class="form-label">Password</label>
					<div class="mb-4">
						<input id="password" name="password" type="password" class="light-text form-control {form?.area == 'password' ? 'is-invalid' : 'valid'}" placeholder="Password" />
						{#if form?.area == "password"}
							<small class="col-12 mb-3 text-danger">{form.msg}</small>
						{/if}
					</div>

					<label for="password" class="form-label">Confirm Password</label>
					<div class="mb-4">
						<input id="cpassword" name="cpassword" type="password" class="light-text form-control {form?.area == 'cpassword' ? 'is-invalid' : 'valid'}" placeholder="Confirm Password" />
						{#if form?.area == "cpassword"}
							<small class="col-12 mb-3 text-danger">{form.msg}</small>
						{/if}
					</div>

					<label for="regkey" class="form-label">Registration key</label>
					<div class="mb-5">
						<input id="regkey" name="regkey" type="password" class="light-text form-control {form?.area == 'regkey' ? 'is-invalid' : 'valid'}" placeholder="mercurkey-12311121123" />
						{#if form?.area == "regkey"}
							<small class="col-12 mb-3 text-danger">{form.msg}</small>
						{/if}
					</div>

					{#if form?.area == "unexp"}
						<p class="col-12 mb-3 text-danger">{form.msg}</p>
					{/if}
					<button type="submit" class="container-fluid btn btn-primary mb-3">Register</button>
				</fieldset>
			</form>
			<p>
				By signing up, you agree to our
				<a href="/terms" class="text-decoration-none">Terms of Service</a>
				and
				<a href="/privacy" class="text-decoration-none">Privacy policy</a>.
			</p>
		</div>
	</div>
</div>

<style lang="sass">
	h1
		font-size: 3.5rem
	a
		color: var(--mainaccent)

	.more
		margin-top: -0.7rem

	.row
		height: 100vh
	.col
		padding: 8vw
		padding-top: 5vh
		padding-bottom: 0

	@media only screen and (min-width: 993px)
		.col
			padding-top: 11vh

	#light
		background: var(--background)
	#dark
		background: linear-gradient(-20deg, var(--footer) 50%, var(--mainaccent) 250%)


	#login
		max-width: 30rem
		form 
			button
				background: var(--mainaccent)
				border-color: var(--mainaccent)

	input
		background-color: var(--accent)
	.valid
		border-color: var(--accent3)

	#wavep // rpcs3 momnt
		div
			transition: all 1s ease-in-out 0s
			div
				background: url("/landing/wave.svg") repeat-x
				top: -198px
				width: 6144px
				height: 198px
				animation: 11s cubic-bezier(0.36, 0.45, 0.63, 0.53) 0s infinite normal none running waves
				transform: translate3d(0px,0px,0px)
				@keyframes waves
					0%
						margin-left: -1600px
					100%
						margin-left: 0
			div:nth-of-type(2)
				animation: 11s cubic-bezier(0.4, 0.2, 0.2, 0.2) -0.124s infinite normal none running waves, 11s ease -1.24s infinite normal none running swell
				top: -174px
</style>
