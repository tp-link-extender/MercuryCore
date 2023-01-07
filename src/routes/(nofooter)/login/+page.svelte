<script lang="ts">
	import { enhance } from "$app/forms"
	export let form: any
</script>

<svelte:head>
	<title>Log in - Mercury</title>
</svelte:head>

<div class="row bg-dark">
	<div class="col px-0">
		<div class="container px-0">
			s
			<!--
			<form class="form-group" method="POST" use:enhance>
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
		-->
		</div>
	</div>
	<div class="col px-0">
		<div class="container px-0">
			s
			<!--
			<form class="form-group" method="POST" use:enhance>
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
		-->
		</div>
	</div>
</div>



<style lang="sass">
	input
		background: var(--accent)
		border-color: var(--accent3)
</style>
