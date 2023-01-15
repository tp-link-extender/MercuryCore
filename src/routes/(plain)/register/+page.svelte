<script lang="ts">
	import { enhance } from "$app/forms"
	export let form: any
</script>

<svelte:head>
	<title>Register - Mercury</title>
</svelte:head>

<h1 class="text-center light-text">Register</h1>

<p class="text-center light-text">Already have an account? 
	<a href="/login" class="text-decoration-none">Log in</a>
</p>

<div class="container mt-5 rounded-4">
	<form class="m-auto" method="POST" use:enhance>
		<div class="mb-3">
			{#if form?.area == "username"}
				<input name="username" type="text" class="form-control is-invalid" placeholder="Username" />
			{:else}
				<input name="username" type="text" class="form-control" placeholder="Username" />
			{/if}
		</div>
		<div class="mb-3">
			{#if form?.area == "password"}
				<input name="password" type="password" class="form-control is-invalid" placeholder="Password" />
			{:else}
				<input name="password" type="password" class="form-control" placeholder="Password" />
			{/if}
		</div>
		<div class="mb-3">
			{#if form?.area == "regkey"}
				<input name="regkey" type="password" class="form-control is-invalid" placeholder="Registration Key" />
			{:else}
				<input name="regkey" type="password" class="form-control" placeholder="Registration Key" />
			{/if}
		</div>

		{#if form?.msg}
			<p class="col-12 mb-3 text-danger">{form.msg}</p>
		{/if}
		<button class="container-fluid btn btn-primary">Register</button>
	</form>
</div>

<style lang="sass">
	h1
		margin-top: 10vh

	.container
		background: var(--accent2)
		max-width: 30rem
		padding: 1.25rem

	input
		background: var(--accent)
		border-color: var(--accent3)
</style>
