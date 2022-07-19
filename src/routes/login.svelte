<svelte:head>
	<title>Login - Mercury</title>
</svelte:head>

<h1 class="text-center dark-text">Login</h1>

<div class="container mt-5">
	<form class="m-auto">
		<div class="mb-3">
			<input type="text" class="form-control" placeholder="Username" />
		</div>
		<div class="mb-3">
			<input type="password" class="form-control" placeholder="Password" />
		</div>
		<div class="mb-3 form-check">
			<input type="checkbox" class="form-check-input" id="rememberMe" />
			<label class="form-check-label dark-text" for="rememberMe">Remember me</label>
		</div>
		<button type="submit" class="container-fluid btn btn-primary">Log in</button>
	</form>
</div>

<style lang="sass">
	.container
		background: var(--accent2)
		max-width: 30rem
		border-radius: 1rem
		padding: 1.25rem

	input
		background: var(--accent)
		border: none
</style>
