<script lang="ts">
	import { applyAction, enhance } from "$app/forms"

	function input(name: string, e: any) {
		data[name].value = e.target.value
	}

	let data: any = {
		username: { value: "", invalid: false },
		email: { value: "", invalid: false },
		password: { value: "", invalid: false },
		cpassword: { value: "", invalid: false },
		regkey: { value: "", invalid: false },
	}

	const things = [
		["Endless possibilities", "Create or play your favourite games and customise your character with items on our catalog."],
		["New features", "In addition to full client usability, additional features such as security fixes, QoL fixes and an easy to use website make your experience better."],
		["Same nostalgia", "All of our clients will remain as vanilla as possible, to make sure it's exactly as you remember it."],
	]

	const fields = [
		["username", "Username", "text"],
		["password", "Password", "password"],
	]

	function update(field: string, message: string) {
		data[field].message = message
		return true
	}

	// This system is extremely magicky
	$: data.username.invalid =
		(data.username.value.length < 3 && update("username", "Username must be at least 3 characters")) ||
		(data.username.value.length > 21 && update("username", "Username must be less than 30 characters")) ||
		(!data.username.value.match(/^[A-Za-z0-9_]+$/) && update("username", "Username must be alphanumeric (A-Z, 0-9, _)"))

	$: data.password.invalid =
		// (data.password.value.length < 1 && update("password", "Password must be at least 1 character")) || Doesn't appear anyway if form has no input
		data.password.value.length > 6969 && update("password", "Password must be less than 6969 characters")

	export let form: any
</script>

<svelte:head>
	<meta name="description" content="Log into your Mercury account." />
	<title>Log in - Mercury</title>
</svelte:head>

<div id="wavep" class="w-100 h-100 position-absolute top-0 overflow-hidden">
	<div class="w-100 position-fixed bottom-0">
		<div class="position-absolute" />
		<div class="position-absolute" />
	</div>
</div>

<div class="row">
	<div id="dark" class="col light-text">
		<a type="button" href="/" class="btn btn-lg border-0 px-0"><i class="fa-solid fa-arrow-left me-2" /> Home</a>
		<h1 class="fw-bolder light-text mb-4">Mercury 2 <span class="opacity-50">beta</span></h1>
		{#each things as [thing, more]}
			<div class="thing d-flex flex-row mt-3">
				<div class="ms-3 w-100">
					<h2 class="h4 light-text">{thing}</h2>
					<p class="light-text opacity-75 more">{more}</p>
				</div>
			</div>
		{/each}
	</div>

	<div id="light" class="col col-12 col-lg-6 light-text">
		<div id="login" class="m-auto">
			<h2 class="light-text">Log into your account</h2>
			<p class="light-text">
				Don't yet have an account?
				<a href="/register" class="text-decoration-none">Register</a>
			</p>

			<form
				class="m-auto form-group mt-4"
				method="POST"
				use:enhance={() => {
					return async ({ result }) => {
						if (result.type == "redirect") window.location.reload()
						else await applyAction(result)
					}
				}}
			>
				<!-- use:enhance function prevents lucia getUser() still being undefined after login -->
				<fieldset>
					{#each fields as [name, label, type]}
						<label for={name} class="form-label">{label}</label>
						<div class="mb-4">
							<!-- bind directive cannot be used here, as type is dynamic, and two-way bindings require the type to be determined at compile -->
							<input
								on:input={e => {
									input(name, e)
								}}
								id={name}
								{name}
								{type}
								class="light-text form-control {form?.area == name || (data[name].value && data[name].invalid) ? 'is-invalid' : 'valid'}"
								placeholder={label}
								required
							/>
							{#if form?.area == name || (data[name].value && data[name].invalid)}
								<small class="col-12 mb-3 text-danger">{form?.msg || data[name].message}</small>
							{/if}
						</div>
					{/each}

					{#if form?.area == "unexp"}
						<p class="col-12 mb-3 text-danger">{form.msg}</p>
					{/if}
					<button type="submit" class="container-fluid btn btn-primary mb-3">Log in</button>
				</fieldset>
			</form>
		</div>
	</div>
</div>

<style lang="sass">
	h1
		font-size: 3.5rem
	a
		color: var(--mainaccent)

	.row
		height: 100vh
	.col
		padding: 8vw
		padding-top: 5vh
		padding-bottom: 0

	@media only screen and (min-width: 992px)
		.col
			padding-top: 20vh

	#light
		z-index: 1
		background: var(--background)
	#dark
		z-index: 0
		background: linear-gradient(-20deg, var(--darker) 50%, var(--mainaccent) 250%)

	#login
		max-width: 30rem
		form 
			button
				background: var(--mainaccent)
				border-color: var(--mainaccent)

	#wavep // rpcs3 momnt
		div
			z-index: 1
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
						margin-left: 0
					100%
						margin-left: -1600px
			div:nth-of-type(2)
				animation: 11s cubic-bezier(0.4, 0.2, 0.2, 0.2) -0.124s infinite normal none running waves, 11s ease -1.24s infinite normal none running swell
				top: -174px
</style>
