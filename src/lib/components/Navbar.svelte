<script lang="ts">
	import { getUser, signOut } from "@lucia-auth/sveltekit/client"
	import { invalidateAll } from "$app/navigation"

	const user = getUser()
</script>

<nav class="navbar navbar-expand-lg navbar-dark position-fixed">
	<div class="container">
		<a class="navbar-brand light-text" href="/">Mercury</a>
		<button class="navbar-toggler" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasNavbarExample-expand-lg" aria-controls="offcanvasNavbarExample-expand-lg">
			<span class="navbar-toggler-icon" data-bs-target="#offcanvasNavbarExample-expand-lg" />
		</button>
		<div class="offcanvas offcanvas-start bg-dark" data-bs-hideresize="true" tabindex="-1" id="offcanvasNavbarExample-expand-lg" aria-labelledby="offcanvasNavbarExample-expand-lg">
			<div class="offcanvas-header">
				<h5 class="offcanvas-title" ><a href="/" class=" light-text">Mercury</a></h5>
				<button type="button" class="btn-close btn-close-white text-reset" data-bs-dismiss="offcanvas" aria-label="Close" />
			</div>
			<div class="offcanvas-body">
				{#if $user}
					<div class="navbar-nav">
						<li class="nav-item">
							<a type="button" href="/home" class="btn my-2 my-sm-0 light-text">Home</a>
						</li>
					</div>
				{/if}
				<!-- <a type="button" href="/discover" class="btn my-2 my-sm-0 light-text">Discover</a>
				<a type="button" href="/catalog" class="btn my-2 my-sm-0 light-text">Catalog</a>
				<a type="button" href="/create" class="btn my-2 my-sm-0 light-text">Create</a> -->
				<div id="loggedin" class="navbar-nav">
					{#if !$user}
						<li class="nav-item">
							<a type="button" href="/login" class="btn mb-1 light-text">Log in</a>
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
	</div>
</nav>

<style lang="sass">
	@media only screen and (max-width: 992px)
		.offcanvas-header
			background: var(--accent2)
		.offcanvas-body
			background: var(--accent)
			min-height: 100vh
			display: flex
			flex-direction: column
			
			a, button
				margin-bottom: 1rem
				width: 100%
			a
				text-align: start

		#loggedin
			margin-top: auto
			margin-bottom: 4rem


	@media only screen and (min-width: 993px)
		#loggedin
			margin-left: auto

	.offcanvas-title a
		text-decoration: none

	nav
		z-index: 9
		width: 100vw
		max-height: 10vh
		backdrop-filter: blur(8px)
	.offcanvas
		box-shadow: none !important	
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
