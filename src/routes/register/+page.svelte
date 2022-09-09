<script lang="ts">
	export let form: any
</script>

<svelte:head>
	<title>Register - Mercury</title>
</svelte:head>

<h1 class="text-center light-text">Register</h1>

<div class="container mt-5">
	<form class="m-auto" method="POST">
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

		{#if form?.msg}
			<p class="col-12 mb-3 text-danger">{form.msg}</p>
		{/if}
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
</style>
