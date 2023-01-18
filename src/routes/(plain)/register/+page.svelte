<script lang="ts">
	import { applyAction, enhance } from "$app/forms"

	let data: any = {
		username: { value: "", invalid: false, message: "" },
		email: { value: "", invalid: false, message: "" },
		password: { value: "", invalid: false, message: "" },
		cpassword: { value: "", invalid: false, message: "" },
		regkey: { value: "", invalid: false, message: "" },
	}

	const things = [
		["Original username", "Make sure it is appropriate and between 3-21 characters. Underscores are allowed."],
		["Valid email", "Mercury requires a valid email so you can reset your password at any time."],
		["Secure password", "Make sure your password has a mix of letters, numbers, and symbols to protect against hackers."],
	]

	const fields = [
		["username", "Username", "3-21 characters"],
		["email", "Email Address", "mercury@banland.xyz"],
		["password", "Password", "Password"],
		["cpassword", "Confirm Password", "Confirm Password"],
		["regkey", "Registration Key", "mercurkey-12311121123"],
	]

	function update(field: string, message: string) {
		data[field].message = message
		return true
	}

	// This system is extremely magicky
	$: data.username.invalid =
		(data.username.value.length < 3 && update("username", "Username must be more than 3 characters")) ||
		(data.username.value.length > 21 && update("username", "Username must be less than 30 characters")) ||
		(!data.username.value.match(/^[A-Za-z0-9_]+$/) && update("username", "Username must be alphanumeric (A-Z, 0-9, _)"))

	// todo: EMAIL REGEX!

	$: data.password.invalid =
		// (data.password.value.length < 1 && update("password", "Password must be at least 1 character")) || // Doesn't appear anyway if form has no input
		(data.password.value.length > 6969 && update("password", "Password must be less than 6969 characters"))
	
	$: data.cpassword.invalid =
		(data.password.value != data.cpassword.value && update("cpassword", "The specified password does not match"))

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
					<h4 class="light-text">{thing}</h4>
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
					{#each fields as [name, label, placeholder]}
						<label for={name} class="form-label">{label}</label>
						<div class="mb-4">
							<input
								bind:value={data[name].value}
								id={name}
								{name}
								type="text"
								class="light-text form-control {form?.area == name || (data[name].value && data[name].invalid) ? 'is-invalid' : 'valid'}"
								{placeholder}
							/>
							{#if form?.area == name || (data[name].value && data[name].invalid)}
								<small class="col-12 mb-3 text-danger">{form?.msg || data[name].message}</small>
							{/if}
						</div>
					{/each}

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
