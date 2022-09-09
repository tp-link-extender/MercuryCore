<script lang="ts">
	import { getSession, signOut } from "lucia-sveltekit/client"
	import { redirect } from "@sveltejs/kit"
	import { goto } from "$app/navigation"

	const session = getSession()
</script>

<nav class="navbar navbar-expand-lg navbar-dark position-fixed">
	<div class="container">
		<a class="navbar-brand light-text" href="/">Mercury</a>
		<div class="d-flex">
			{#if $session}
				<a type="button" href="/home" class="btn my-2 my-sm-0 light-text">Home</a>
			{/if}
			<a type="button" href="/discover" class="btn my-2 my-sm-0 light-text">Discover</a>
			<a type="button" href="/catalog" class="btn my-2 my-sm-0 light-text">Catalog</a>
		</div>
		<div class="d-flex">
			{#if !$session}
				<a type="button" href="/register" class="btn btn-success my-2 my-sm-0">Register</a>
				<a type="button" href="/login" class="btn btn-success my-2 my-sm-0">Login</a>
			{:else}
				<button
					on:click={async () => {
						await signOut($session?.access_token || "") // prevent dumb errors
						window.location.reload()
						// I have no clue if this is a good way to do this
						// I tried it, and it worked
						// TODO: make it not rely on js
					}}
					class="btn btn-success my-2 my-sm-0">Logout</button
				>
			{/if}
		</div>
	</div>
</nav>

<style lang="sass">
	nav
		z-index: 9
		width: 100vw
		max-height: 10vh
		backdrop-filter: blur(6px)
		a
			margin-right: 0.5rem
</style>
