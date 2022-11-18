<script lang="ts">
	import { getUser } from "@lucia-auth/sveltekit/client"
	import { signOut } from "@lucia-auth/sveltekit/client"

	const user = getUser()
</script>

<nav class="navbar navbar-expand-lg navbar-dark position-fixed">
	<div class="container">
		<a class="navbar-brand light-text" href="/">Mercury</a>
		<div class="d-flex">
			{#if $user}
				<a type="button" href="/home" class="btn my-2 my-sm-0 light-text">Home</a>
			{/if}
			<!-- <a type="button" href="/discover" class="btn my-2 my-sm-0 light-text">Discover</a>
			<a type="button" href="/catalog" class="btn my-2 my-sm-0 light-text">Catalog</a>
			<a type="button" href="/create" class="btn my-2 my-sm-0 light-text">Create</a> -->
		</div>
		<div class="d-flex">
			{#if !$user}
				<a type="button" href="/login" class="btn btn-success my-2 my-sm-0">Login</a>
				<a type="button" href="/register" class="btn btn-success my-2 my-sm-0">Register</a>
			{:else}
				<a id="username" href="/{$user?.username}" class="d-flex">
					<div id="pfp" class="mx-2">
						<img src={$user?.image} alt="You" />
					</div>
					<p class="light-text my-auto fs-6 me-4">
						{$user?.displayname || $user?.username}
					</p>
				</a>
				<button
					on:click={async () => {
						await signOut()
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
		backdrop-filter: blur(8px)
		a
			margin-right: 0.5rem
		img
			border-radius: 50%

	#pfp
		background: var(--accent2)
		border-radius: 50%
		width: 2.5rem
		height: 2.5rem
		img
			width: 2.5rem
			height: 2.5rem
	
	#username
		text-decoration: none
</style>
