<svelte:head>
	<title>Register - Mercury</title>
</svelte:head>

<h1 class="text-center light-text">Register</h1>

<div class="container mt-5">
	<form class="m-auto" action="/api/register" method="post">
		<div class="mb-3">
			<input name="username" type="text" class="form-control" placeholder="Username" />
		</div>
		<div class="mb-3">
			<input name="password" type="password" class="form-control" placeholder="Password" />
		</div>
		<div class="mb-3">
			<input name="regkey" type="password" class="form-control" placeholder="Registration Key" />
		</div>
		<div class="mb-3 form-check">
			<input type="checkbox" class="form-check-input" id="rememberMe" />
			<label class="form-check-label light-text" for="rememberMe">Remember me</label>
		</div>

		<div id="errors" class="col-12 mb-3 text-danger">
			<p id="error">An unexpected error occured</p>
			<p id="ushort">Username must be more than 3 characters</p>
			<p id="ulong">Username must be less than 30 characters</p>
			<p id="pshort">Password must be at least 16 characters</p>
			<p id="plong">Password must be less than 6969 characters</p>
			<p id="taken">Username already taken</p>
		</div>
		<!-- Because I couldn't get it working from the endpoint -->

		<button type="submit" class="container-fluid btn btn-primary">Register</button>
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

	#errors p
		display: none
		&:target
			display: block
</style>
