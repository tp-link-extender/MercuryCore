<script lang="ts">
	import { enhance } from "$app/forms"
	export let form: any
</script>

<svelte:head>
	<title>Log in - Mercury</title>
</svelte:head>

<h1 class="text-center light-text">Log in</h1>

<div class="container mt-5">
	<form class="m-auto" method="POST" use:enhance>
		<div class="mb-3">
			<input name="username" type="text" class="form-control" placeholder="Username" />
		</div>
		<div class="mb-3">
			<input name="password" type="password" class="form-control" placeholder="Password" />
		</div>

		{#if form?.msg}
			<p class="col-12 mb-3 text-danger">{form.msg}</p>
		{/if}

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
		color: white

		&::placeholder
			color: var(--grey-text)
</style>
