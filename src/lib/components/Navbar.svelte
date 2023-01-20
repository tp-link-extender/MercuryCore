<script lang="ts">
	import { getUser, signOut } from "@lucia-auth/sveltekit/client"
	import { invalidateAll } from "$app/navigation"

	const user = getUser()
</script>

<nav class="navbar navbar-expand-lg navbar-dark position-fixed vw-100">
	<div class="container">
		<a class="navbar-brand light-text" href="/">Mercury</a>
		<button class="navbar-toggler" type="button" title="Open sidebar" data-bs-toggle="offcanvas" data-bs-target="#offcanvasNavbarExample-expand-lg" aria-controls="offcanvasNavbarExample-expand-lg">		
			<span class="navbar-toggler-icon" data-bs-target="#offcanvasNavbarExample-expand-lg" />
		</button>
		<div class="offcanvas offcanvas-start border-0 text-bg-dark" data-bs-hideresize="true" tabindex="-1" id="offcanvasNavbarExample-expand-lg" aria-labelledby="offcanvasNavbarExample-expand-lg">
			<div class="offcanvas-header">
				<a href="/" class="offcanvas-title light-text h5">Mercury</a>
				<button type="button" class="btn-close btn-close-white text-reset me-1" data-bs-dismiss="offcanvas" aria-label="Close" />
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
						<div class="dropdown">
							<a href="/{$user?.username}" role="button" data-bs-toggle="dropdown" aria-expanded="false" class="d-flex text-decoration-none mb-1">
								<div id="pfp" class="mx-2 rounded-circle">
									<img src={$user?.image} alt="You" class="rounded-circle rounded-top-0" />
								</div>
								<p class="light-text my-auto fs-6 me-4">
									{$user?.displayname || $user?.username}
									<i class="fa-solid fa-ellipsis-vertical ms-2" />
								</p>
							</a>

							<ul class="dropdown-menu mt-2">
								<li><h6 class="dropdown-header">ACCOUNT</h6></li>
								<li><a class="dropdown-item light-text" href="/{$user?.username}">Profile</a></li>
								<li><a class="dropdown-item light-text" href="/{$user?.username}">Inventory</a></li>
								<li><a class="dropdown-item light-text" href="/{$user?.username}">Avatar</a></li>
								<li><a class="dropdown-item light-text" href="/{$user?.username}">My Groups</a></li>
								<li><hr class="dropdown-divider" /></li>
								<li><a class="dropdown-item light-text" href="/{$user?.username}"><i class="fa-solid fa-user-gear" /> Settings</a></li>
								<li>
									<button
										on:click={async () => {
											await signOut()
											invalidateAll()
											window.location.reload()
										}}
										class="dropdown-item text-danger"><b><i class="fa-solid fa-arrow-right-from-bracket" /> Log out</b></button
									>
								</li>
							</ul>
						</div>
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
			
			a
				margin-bottom: 1rem
				width: 100%
				text-align: start

		#loggedin
			margin-top: auto
			margin-bottom: 4rem
	
	@media only screen and (max-width: 768px) and (orientation: portrait)
		#loggedin
			margin-bottom: 10rem
	
	@media only screen and (max-width: 768px) and (orientation: landscape)
		#loggedin
			margin-bottom: 6rem



	@media only screen and (min-width: 993px)
		#loggedin
			margin-left: auto


	.offcanvas-title
		text-decoration: none

	nav
		z-index: 9
		max-height: 10vh
		-webkit-backdrop-filter: blur(10px)
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

	.dropdown-menu
		background: var(--footer)
		border: none

</style>
