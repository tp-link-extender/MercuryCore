<script lang="ts">
	import { getUser, signOut } from "@lucia-auth/sveltekit/client"
	import { invalidateAll } from "$app/navigation"

	const user = getUser()
</script>

<nav class="navbar navbar-expand-lg navbar-dark navbar-fixed-top position-fixed">
	<div class="container">
		<a class="navbar-brand light-text" href="/">Mercury</a>
		<button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarText" aria-controls="navbarText" aria-expanded="false" aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div class="collapse navbar-collapse" id="navbarText">
		<div class="d-flex">
			{#if $user}
				<a type="button" href="/home" class="btn my-2 my-sm-0 light-text">Home</a>
			{/if}
			<!-- <a type="button" href="/discover" class="btn my-2 my-sm-0 light-text">Discover</a>
			<a type="button" href="/catalog" class="btn my-2 my-sm-0 light-text">Catalog</a>
			<a type="button" href="/create" class="btn my-2 my-sm-0 light-text">Create</a> -->
		</div>
		<div class="navbar-nav ms-auto">
			{#if !$user}
			  <li class="nav-item">
				<a type="button" href="/login" class="btn light-text">Login</a>
			  </li>
			  <li class="nav-item">
				<a type="button" href="/register" class="btn btn-success my-2 my-sm-0">Register</a>
			  </li>
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
						invalidateAll()
						window.location.reload()
					}}
					class="btn btn-success my-2 my-sm-0">Logout</button
				>
			{/if}
		</div>
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
