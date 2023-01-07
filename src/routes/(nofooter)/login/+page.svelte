<script lang="ts">
	import { enhance } from "$app/forms"
	export let form: any
</script>

<svelte:head>
	<title>Log in - Mercury</title>
</svelte:head>

<h1 class="text-center light-text">Log in</h1>

<div class="container mt-5">
	<form class="m-auto form-group" method="POST" use:enhance>
		<fieldset>
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

			{#if form?.msg}
				<p class="col-12 mb-3 text-danger">{form.msg}</p>
			{/if}

			<button type="submit" class="container-fluid btn btn-primary">Log in</button>
		</fieldset>
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
		border-color: var(--accent3)
</style>
