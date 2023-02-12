<script lang="ts">
	import { enhance } from "$app/forms"
	import { goto } from "$app/navigation"
	import { getUser } from "@lucia-auth/sveltekit/client"

	let search = ""

	const user = getUser()
</script>

<nav class="navbar navbar-expand-md navbar-dark position-fixed w-100 px-4 py-1">
	<div class="container">
		<a class="navbar-brand light-text me-5" href="/">Mercury</a>
		<button class="navbar-toggler" type="button" title="Open sidebar" data-bs-toggle="offcanvas" data-bs-target="#offcanvasNavbar-expand-md" aria-controls="offcanvasNavbar-expand-md">
			<span class="navbar-toggler-icon" data-bs-target="#offcanvasNavbar-expand-md" />
		</button>
		<div class="offcanvas offcanvas-start border-0 text-bg-dark" data-bs-hideresize="true" tabindex="-1" id="offcanvasNavbar-expand-md" aria-labelledby="offcanvasNavbar-expand-md">
			<div class="offcanvas-header">
				<a href="/" class="offcanvas-title light-text h5">Mercury</a>
				<button type="button" class="btn-close btn-close-white text-reset me-1" data-bs-dismiss="offcanvas" aria-label="Close" />
			</div>
			<div class="offcanvas-body d-flex">
				{#if $user}
					<ul class="navbar-nav">
						<li class="nav-item">
							<a href="/games" class="nav-link mt-1 shadow-none mr-0 light-text">Games</a>
						</li>
						<li class="nav-item">
							<a href="/avatarshop" class="nav-link mt-1 shadow-none mr-0 light-text">Avatar Shop</a>
						</li>
					</ul>
					<ul class="navbar-nav loggedin">
						<li class="nav-item">
							<form use:enhance method="POST" action="/search" class="my-1" role="search">
								<div class="input-group">
									<input bind:value={search} class="form-control valid" name="query" type="search" placeholder="Search" aria-label="Search" />
									<button on:click|preventDefault={() => (search ? goto(`/search?q=${search}&c=users`) : null)} class="btn btn-success py-0" type="submit" title="Search"
										><i class="fa fa-search" /></button
									>
								</div>
								{#if search}
									<div id="results" class="position-absolute card p-2 mt-2">
										<a class="btn text-start light-text py-2" href="/search?q={search}&c=users" title="Search users">Search users for <b>{search}</b></a>
										<a class="btn text-start light-text py-2" href="/search?q={search}&c=places" title="Search places">Search places for <b>{search}</b></a>
										<a class="btn text-start light-text py-2" href="/search?q={search}&c=items" title="Search avatar shop">Search avatar shop for <b>{search}</b></a>
									</div>
								{/if}
							</form>
						</li>
						<li class="nav-item">
							<a id="rocks" href="/transactions" class="fw-bold nav-link mt-1 text-success shadow-none">
								<i class="fa fa-gem me-1" />
								<span class="h6 text-success">
									{$user.currency}
								</span>
							</a>
						</li>
						<li class="dropdown ms-2">
							<a href="/user/{$user.number}" role="button" data-bs-toggle="dropdown" aria-expanded="false" class="d-flex text-decoration-none mb-1">
								<div id="pfp" class="mx-2 rounded-circle">
									<img src={$user?.image} alt="You" class="rounded-circle rounded-top-0" />
								</div>
								<p class="light-text my-auto fs-6 me-4">
									{$user?.displayname}
									<i class="fa fa-ellipsis-vertical ms-2" />
								</p>
							</a>

							<ul class="dropdown-menu mt-2">
								<li><h6 class="dropdown-header">ACCOUNT</h6></li>
								<li><a class="dropdown-item light-text" href="/user/{$user.number}"><i class="fa fa-address-card me-2" /> Profile</a></li>
								<li><a class="dropdown-item light-text" href="/user/{$user.number}"><i class="fa fa-box-open me-2" /> Inventory</a></li>
								<li><a class="dropdown-item light-text" href="/requests"><i class="fa fa-user-plus me-2" /> Friend requests</a></li>
								<li><a class="dropdown-item light-text" href="/user/{$user.number}"><i class="fa fa-user-pen me-2" /> Avatar</a></li>
								<li><a class="dropdown-item light-text" href="/user/{$user.number}"><i class="fa fa-users me-2" /> My Groups</a></li>
								<li><hr class="dropdown-divider" /></li>
								<li><a class="dropdown-item light-text" href="/user/settings"><i class="fa fa-gears me-2" /> Settings</a></li>
								<li>
									<form use:enhance method="POST" action="/logout">
										<button type="submit" class="dropdown-item text-light text-bg-danger"><b><i class="fa fa-arrow-right-from-bracket me-2" /> Log out</b></button>
									</form>
								</li>
							</ul>
						</li>
					</ul>
				{:else}
					<ul class="navbar-nav loggedin">
						<li class="nav-item">
							<a type="button" href="/login" class="btn mb-1 light-text">Log in</a>
						</li>
						<li class="nav-item">
							<a type="button" href="/register" class="btn btn-success my-2 my-sm-0">Register</a>
						</li>
					</ul>
				{/if}
			</div>
		</div>
	</div>
</nav>

<style lang="sass">
	@media only screen and (max-width: 767px)
		.offcanvas-header
			background: var(--accent2)
		.offcanvas-body
			background: var(--accent)
			min-height: 100vh
			flex-direction: column-reverse
			justify-content: start

			a
				margin-bottom: 1rem
				width: 100%
				text-align: start

			.loggedin
				margin-bottom: 2rem

	@media only screen and (min-width: 768px)
		.loggedin
			margin-left: auto

	.loggedin
		padding: 0


	.offcanvas-title
		text-decoration: none

	nav
		z-index: 9
		max-height: 10vh
		backdrop-filter: blur(8px)
		-webkit-backdrop-filter: blur(8px)
		border-bottom: 1px solid #fff1
		background: #0003

	.offcanvas
		box-shadow: none !important

	a
		margin-right: 0.5rem

	#pfp
		background: var(--accent)
		width: 2.5rem
		height: 2.5rem

	img
		width: 2.5rem
		height: 2.5rem

	.dropdown-menu
		background: var(--darker)
		border: none

	#results
		background: var(--darker)
		min-width: 15rem
		a:hover
				background: var(--accent2)

	.input-group
		min-width: 15rem
		font-size: 0.8rem
		button, input
			height: 2.3rem
</style>
