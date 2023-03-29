<script lang="ts">
	import { applyAction, enhance } from "$app/forms"

	const input = (name: string, e: any) => (data[name].value = e.target.value)

	let data: any = {
		username: { value: "", invalid: false, message: "" },
		email: { value: "", invalid: false, message: "" },
		password: { value: "", invalid: false, message: "" },
		cpassword: { value: "", invalid: false, message: "" },
		regkey: { value: "", invalid: false, message: "" },
	}

	const fields = [
		["username", "Username", "3-21 characters", "text"],
		["email", "Email Address", "mercury@banland.xyz", "email"],
		["password", "Password", "Password", "password"],
		["cpassword", "Confirm Password", "Confirm Password", "password"],
		["regkey", "Registration Key", "mercurkey-12311121123", "password"],
	]

	function update(field: string, message: string) {
		data[field].message = message
		return true
	}

	// This system is extremely magicky
	$: data.username.invalid =
		(data.username.value.length < 3 &&
			update("username", "Username must be at least 3 characters")) ||
		(data.username.value.length > 21 &&
			update("username", "Username must be less than 30 characters")) ||
		(!data.username.value.match(/^[A-Za-z0-9_]+$/) &&
			update("username", "Username must be alphanumeric (A-Z, 0-9, _)"))

	// todo: EMAIL REGEX!

	$: data.password.invalid =
		// (data.password.value.length < 1 && update("password", "Password must be at least 1 character")) || // Doesn't appear anyway if form has no input
		data.password.value.length > 6969 &&
		update("password", "Password must be less than 6969 characters")

	$: data.cpassword.invalid =
		data.password.value != data.cpassword.value &&
		update("cpassword", "The specified password does not match")

	export let form
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

	<div id="light" class="col col-12 col-lg-6 light-text bg-background">
		<div id="login" class="m-auto">
			<h2 class="light-text">Create a free account</h2>
			<p class="light-text">
				Already have an account?
				<a href="/login" class="text-decoration-none">Log in</a>
			</p>

			<form
				class="m-auto form-group mt-4"
				method="POST"
				use:enhance={() =>
					async ({ result }) =>
						result.type == "redirect"
							? window.location.reload()
							: await applyAction(result)}>
				<!-- 
					The use:enhance function prevents lucia getUser() still being undefined after login,
					while still allowing the form to update without reloading when an error occurs.
				-->
				<fieldset>
					{#each fields as [name, label, placeholder, type]}
						<label for={name} class="form-label">{label}</label>
						<div class="mb-4">
							<!--
								Bind directive cannot be used here, as type is dynamic, and two-way
								bindings require the type to be determined at compile time.
							-->
							<input
								on:input={e => input(name, e)}
								id={name}
								{name}
								{type}
								class="light-text form-control {form?.area ==
									name ||
								(data[name].value && data[name].invalid)
									? 'is-invalid'
									: 'valid'}"
								{placeholder}
								required />
							{#if form?.area == name || (data[name].value && data[name].invalid)}
								<small class="col-12 mb-3 text-danger">
									{form?.msg || data[name].message}
								</small>
							{/if}
						</div>
					{/each}

					{#if form?.area == "unexp"}
						<p class="col-12 mb-3 text-danger">{form.msg}</p>
					{/if}
					<button
						type="submit"
						class="container-fluid btn btn-primary mb-3">
						Register
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

<style lang="sass">
	@use "../loginregister.sass"

	@keyframes waves
		0%
			margin-left: -1600px
		100%
			margin-left: 0

	@media only screen and (min-width: 992px)
		.col
			padding-top: 11vh
</style>
