<script lang="ts">
	import { getUser, signOut } from "@lucia-auth/sveltekit/client"
	import { invalidateAll } from "$app/navigation"

	const user = getUser()
</script>

<nav class="navbar navbar-expand-lg navbar-dark position-fixed vw-100">
	<div class="container">
		<a class="navbar-brand light-text" href="/">Mercury</a>
		<button class="navbar-toggler" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasNavbarExample-expand-lg" aria-controls="offcanvasNavbarExample-expand-lg">
			<span class="navbar-toggler-icon" data-bs-target="#offcanvasNavbarExample-expand-lg" />
		</button>
		<div class="offcanvas offcanvas-start border-0 text-bg-dark" data-bs-hideresize="true" tabindex="-1" id="offcanvasNavbarExample-expand-lg" aria-labelledby="offcanvasNavbarExample-expand-lg">
			<div class="offcanvas-header">
				<a href="/" class="offcanvas-title light-text h5">Mercury</a>
				<button type="button" class="btn-close btn-close-white text-reset" data-bs-dismiss="offcanvas" aria-label="Close" />
			</div>
			<div class="offcanvas-body d-flex">
				{#if $user}
					<div class="navbar-nav">
						<li class="nav-item">
							<a type="button" href="/home" class="btn my-2 my-sm-0 light-text">Home</a>
						</li>
					</div>
				{/if}
				<!-- <a type="button" href="/catalog" class="btn my-2 my-sm-0 light-text">Catalog</a>
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
							<div id="pfp" class="mx-2 rounded-circle">
								<img src={$user?.image} alt="You" class="rounded-circle rounded-top-0"/>
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
							class="btn btn-danger my-2 my-sm-0">Log out</button
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
			background: var(--accent3)
		.offcanvas-body
			background: var(--accent2)
			min-height: 100vh
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

	.offcanvas-title
		text-decoration: none

	nav
		z-index: 9
		max-height: 10vh
		backdrop-filter: blur(8px)
		
	.offcanvas
		box-shadow: none !important	

	a
		margin-right: 0.5rem

	#pfp
		background: var(--accent2)
		width: 2.5rem
		height: 2.5rem

	img
		width: 2.5rem
		height: 2.5rem

	#username
		text-decoration: none
</style>
