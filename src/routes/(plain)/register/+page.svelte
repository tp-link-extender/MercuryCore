<script lang="ts">
	import { enhance } from "$app/forms"
	import { ArrowLeft, CheckCircleFill } from "svelte-bootstrap-icons"

	const things = [
		["Original username", "Make sure it is appropriate and between 3-21 characters."],
		["Valid email", "Mercury requires a valid email so you can reset your password at any time."],
		["Secure password", "Make sure your password has a mix of letters, numbers, and symbols to protect against hackers."],
	]

	export let form: any
</script>

<svelte:head>
	<title>Register - Mercury</title>
</svelte:head>

<div id="all" class="overflow-x-hidden">
	<div class="row">
		<div class="col light-text" id="dark">
			<a type="button" href="/" class="btn btn-lg border-0"><ArrowLeft class="me-2" /> Home</a>
			<h1 class="fw-bolder light-text mb-4">Mercury 2 <span class="opacity-50">beta</span></h1>
			{#each things as [thing, more]}
				<div class="thing d-flex flex-row mt-3">
					<CheckCircleFill height={24} width={24} color="#ea085c" />
					<div class="ms-3">
						<p class="h4 light-text">{thing}</p>
						<p class="light-text opacity-75 more">{more}</p>
					</div>
				</div>
			{/each}
		</div>

		<div class="col col-12 col-lg-6 light-text">
			<div id="login" class="m-auto">
				<h2 class="light-text">Create a free account</h2>
				<p class="light-text">
					Already have an account?
					<a href="/login" class="text-decoration-none">Log in</a>
				</p>

				<form class="m-auto form-group mt-4" method="POST" use:enhance>
					<fieldset>
						<div class="mb-4">
							<label for="username" class="form-label">Username</label>
							{#if form?.area == "username"}
								<input id="username" name="username" type="text" class="light-text form-control is-invalid" placeholder="3-21 characters" />
							{:else}
								<input id="username" name="username" type="text" class="light-text form-control" placeholder="3-21 characters" />
							{/if}
						</div>
						<label for="password" class="form-label">Password</label>
						<div class="mb-4">
							{#if form?.area == "password"}
								<input id="password" name="password" type="password" class="light-text form-control is-invalid" placeholder="Password" />
							{:else}
								<input id="password" name="password" type="password" class="light-text form-control" placeholder="Password" />
							{/if}
						</div>
						<label for="regkey" class="form-label">Registration key</label>
						<div class="mb-5">
							{#if form?.area == "regkey"}
								<input id="regkey" name="regkey" type="password" class="light-text form-control is-invalid" placeholder="mercurkey-12311121123" />
							{:else}
								<input id="regkey" name="regkey" type="password" class="light-text form-control" placeholder="mercurkey-12311121123" />
							{/if}
						</div>

						<button type="submit" class="container-fluid btn btn-danger mb-3">Register</button>
						{#if form?.msg}
							<p class="col-12 mb-3 text-danger">{form.msg}</p>
						{/if}
					</fieldset>
				</form>
				<p>By signing up, you agree to our
					<a href="/terms" class="text-decoration-none">Terms of Service</a>
					and
					<a href="/privacy" class="text-decoration-none">Privacy policy</a>.
				</p>
			</div>
		</div>
	</div>
</div>

<style lang="sass">
	h1
		font-size: 3.5rem

	a
		color: #ea085c

	.more
		margin-top: -0.7rem

	.row
		height: 100vh
	.col
		padding: 8vw
		padding-top: 5vh

	@media only screen and (min-width: 993px)
		.col
			padding-top: 20vh

	#dark
		background: var(--footer)

	#login
		max-width: 30rem
		form 
			button
				background: #ea085c

	input
		background: var(--accent)
		border-color: var(--accent3)
</style>
