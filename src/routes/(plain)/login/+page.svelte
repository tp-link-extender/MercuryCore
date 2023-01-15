<script lang="ts">
	import { enhance } from "$app/forms"
	import { ArrowLeft } from "svelte-bootstrap-icons"

	export let form: any
</script>

<svelte:head>
	<title>Log in - Mercury</title>
</svelte:head>

<div id="all" class="overflow-x-hidden">
	<div class="row">
		<div class="col light-text" id="dark">
			<a type="button" href="/" class="btn btn-lg border-0"><ArrowLeft class="me-2" /> Home</a>
			<h1 class="fw-bolder light-text mb-4">Mercury 2 <span class="opacity-50">beta</span></h1>
		</div>

		<div class="col col-12 col-lg-6 light-text">
			<div id="login" class="m-auto">
				<h2 class="light-text">Log into your account</h2>
				<p class="light-text">
					Don't yet have an account?
					<a href="/register" class="text-decoration-none">Register</a>
				</p>

				<form class="m-auto form-group mt-4" method="POST" use:enhance>
					<fieldset>
						<div class="mb-4">
							<label for="username" class="form-label">Username</label>
							{#if form?.area == "username"}
								<input id="username" name="username" type="text" class="light-text form-control is-invalid" placeholder="3-21 characters" />
							{:else}
								<input id="username" name="username" type="text" class="light-text form-control valid" placeholder="3-21 characters" />
							{/if}
						</div>
						<label for="password" class="form-label">Password</label>
						<div class="mb-5">
							{#if form?.area == "password"}
								<input id="password" name="password" type="password" class="light-text form-control is-invalid" placeholder="Password" />
							{:else}
								<input id="password" name="password" type="password" class="light-text form-control valid" placeholder="Password" />
							{/if}
						</div>

						<button type="submit" class="container-fluid btn btn-danger mb-3">Log in</button>
						{#if form?.msg}
							<p class="col-12 mb-3 text-danger">{form.msg}</p>
						{/if}
					</fieldset>
				</form>
			</div>
		</div>
	</div>
</div>

<style lang="sass">
	h1
		font-size: 3.5rem

	a
		color: #ea085c

	.row
		height: 100vh
	.col
		padding: 8vw
		padding-top: 5vh

	@media only screen and (min-width: 992px)
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
		background-color: var(--accent)
	.valid
		border-color: var(--accent3)
</style>
