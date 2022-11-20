<script lang="ts">
	import { enhance } from "$app/forms"
	export let form: any
</script>

<svelte:head>
	<title>Login - Mercury</title>
</svelte:head>
<div class="container d-flex justify-content-center align-items-center mt-5">
	<div class="row">
		<div class="col">
        <button>sass</button>
		</div>
		<div class="col">
			<form
			class="m-auto"
			method="POST"
			use:enhance
		>
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
	</div>
</div>

<style lang="sass">

</style>