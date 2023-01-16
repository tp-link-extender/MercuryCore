<script lang="ts">
	import { enhance } from "$app/forms"

	const things = [
		["Endless possibilities", "Create or play your favourite games and customise your character with items on our catalog."],
		["New features", "In addition to full client usability, additional features such as security fixes, QoL fixes and an easy to use website make your experience better."],
		["Same nostalgia", "All of our clients will remain as vanilla as possible, to make sure it's exactly as you remember it."],
	]

	export let form: any
</script>

<svelte:head>
	<title>Log in - Mercury</title>
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
							<input id="username" name="username" type="text" class="light-text form-control is-invalid" placeholder="Username" />
							<p class="col-12 mb-3 text-danger">{form.msg}</p>
						{:else}
							<input id="username" name="username" type="text" class="light-text form-control valid" placeholder="Username" />
						{/if}
					</div>
					<label for="password" class="form-label">Password</label>
					<div class="mb-5">
						{#if form?.area == "password"}
							<input id="password" name="password" type="password" class="light-text form-control is-invalid" placeholder="Password" />
							<p class="col-12 mb-3 text-danger">{form.msg}</p>
						{:else}
							<input id="password" name="password" type="password" class="light-text form-control valid" placeholder="Password" />
						{/if}
					</div>

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
				background: url("/wave.svg") repeat-x
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
