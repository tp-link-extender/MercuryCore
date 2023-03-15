<script lang="ts">
	import type { LayoutData } from "../../routes/$types"
	import { enhance } from "$app/forms"
	import { goto } from "$app/navigation"
	import { fade } from "svelte/transition"
	import { getUser } from "@lucia-auth/sveltekit/client"

	let search = ""

	const user = getUser()

	export let data: LayoutData
</script>

<nav class="navbar navbar-expand-lg navbar-dark py-0">
	<a class="navbar-brand light-text mx-4 mobile-brand" href="/">Mercury</a>
	<button
		class="navbar-toggler ms-auto my-1 me-3"
		type="button"
		title="Open sidebar"
		data-bs-toggle="offcanvas"
		data-bs-target="#offcanvasNavbar-expand-lg"
		aria-controls="offcanvasNavbar-expand-lg"
	>
		<span class="navbar-toggler-icon" data-bs-target="#offcanvasNavbar-expand-lg" />
	</button>
	<div class="offcanvas offcanvas-start border-0" data-bs-hideresize="true" tabindex="-1" id="offcanvasNavbar-expand-lg" aria-labelledby="offcanvasNavbar-expand-lg">
		<div class="offcanvas-header">
			<a href="/" class="offcanvas-title light-text h5">Mercury</a>
			<button type="button" class="btn-close btn-close-white text-reset me-1" data-bs-dismiss="offcanvas" aria-label="Close" />
		</div>

		<div id="nav1" class="offcanvas-body px-4 py-1 d-flex">
			<a class="navbar-brand light-text me-4 mt-1" href="/">Mercury</a>
			{#if $user}
				<div class="navbar-nav">
					<a class="btn mt-1 px-1 light-text nav-item" href="/">Home</a>
					<a class="btn mt-1 px-1 light-text nav-item" href="/games">Games</a>
					<a class="btn mt-1 px-1 light-text nav-item" href="/avatarshop">Avatar Shop</a>
					<!-- <a class="btn mt-1 px-1 light-text nav-item" href="/groups">Groups</a> -->
					<a class="btn mt-1 px-1 light-text nav-item" href="/forum">Forum</a>
					{#if $user?.permissionLevel >= 4}
						<a class="btn mt-1 px-1 light-text nav-item" href="/admin">Admin</a>
					{/if}
				</div>
				<div id="search" class="navbar-nav ms-4 me-auto mt-1">
					<form use:enhance method="POST" action="/search" class="w-auto" role="search">
						<div class="input-group">
							<input bind:value={search} class="form-control valid" name="query" type="search" placeholder="Search" aria-label="Search" />
							<button on:click|preventDefault={() => (search ? goto(`/search?q=${search}&c=users`) : null)} class="btn btn-success py-0" type="submit" title="Search">
								<i class="fa fa-search" />
							</button>
						</div>
						{#if search}
							<div transition:fade={{ duration: 150 }} id="results" class="position-absolute card p-2 pe-0 mt-2">
								<a class="btn text-start light-text py-2" href="/search?q={search}&c=users" title="Search Users">Search <b>{search}</b> in Users</a>
								<a class="btn text-start light-text py-2" href="/search?q={search}&c=places" title="Search Places">Search <b>{search}</b> in Places</a>
								<a class="btn text-start light-text py-2" href="/search?q={search}&c=items" title="Search Avatar shop">Search <b>{search}</b> in Avatar shop</a>
								<!-- <a class="btn text-start light-text py-2" href="/search?q={search}&c=groups" title="Search Groups">Search <b>{search}</b> in Groups</a> -->
							</div>
						{/if}
					</form>
				</div>
				<ul class="navbar-nav loggedin m-0">
					<li class="dropdown ms-3 me-2 pt-1">
						<a href="/transactions/your" role="button" class="fw-bold nav-link text-success">
							<i class="fa fa-gem me-1 text-success" />
							<span class="h6 text-success">
								{$user.currency}
							</span>
						</a>
					</li>
					<li class="dropdown">
						<a href="/user/{$user.number}" role="button" data-bs-toggle="dropdown" aria-expanded="false" class="fw-bold nav-item mx-0 text-decoration-none px-0 mb-2">
							<a id="user" href="/user/{$user.number}" class="btn p-0 d-flex text-decoration-none light-text w-50">
								<div id="pfp" class="mx-2 rounded-circle">
									<img src={$user?.image} alt="You" class="rounded-circle rounded-top-0" />
								</div>
								<p id="username" class="my-auto fs-6 me-2">
									{$user?.username}
								</p>
							</a>
						</a>

						<ul class="dropdown-menu dropdown-menu-end mt-2 mb-2">
							<li><a class="dropdown-item light-text" href="/settings"><i class="fa fa-gears me-2" /> Settings</a></li>
							<li>
								<form use:enhance method="POST" action="/api?/logout">
									<button type="submit" class="dropdown-item text-danger"><b><i class="fa fa-arrow-right-from-bracket me-2" /> Log out</b></button>
								</form>
							</li>
						</ul>
					</li>
				</ul>
			{:else}
				<ul class="navbar-nav loggedin">
					<li class="nav-item mt-1">
						<a type="button" href="/login" class="btn mb-1 light-text">Log in</a>
					</li>
					<li class="nav-item mt-1">
						<a type="button" href="/register" class="btn btn-success my-2 my-sm-0">Register</a>
					</li>
				</ul>
			{/if}
		</div>
		<hr class="pt-0 mb-2" />
		{#if $user}
			<nav id="nav2" class="navbar navbar-dark px-4 py-0 w-100">
				<div id="nav2-1" class="navbar-nav w-50">
					<a class="light-text btn nav-item m-0 py-1" href="/user/{$user.number}">Profile</a>
					<a class="light-text btn nav-item m-0 py-1" href="/inventory">Inventory</a>
					<a class="light-text btn nav-item m-0 py-1" href="/requests">Friends</a>
					<a class="light-text btn nav-item m-0 py-1" href="/avatar">Avatar</a>
				</div>
			</nav>
		{/if}
	</div>
</nav>

{#if data.banners && $user}
	{#each data.banners as announcement}
		<div class="alert py-1 my-0 rounded-0 text-center border-0 text-{announcement.textLight ? 'light' : ''}" role="alert" style="background: {announcement.bgColour}">
			{announcement.body}
	  	</div>
	{/each}
{/if}

<style lang="sass">
	.mobile-brand
		display: none

	@media only screen and (max-width: 991px)
		.offcanvas-header
			background: var(--accent)
		.offcanvas
			background: var(--background)
		.offcanvas-body
			background: var(--background)
			min-height: 100vh
			flex-direction: column-reverse
			justify-content: start
			padding-top: 1rem !important

			a
				margin-bottom: 1rem
				width: 100%
				text-align: start

		hr 
			max-width: 25%
			margin-left: 40% 
			display: block !important

		.loggedin
			margin-bottom: 1rem
			order: 1

		.mobile-brand
			display: block

		#user
			margin-left: 0.5rem !important
			margin-bottom: 1.5rem !important
		
		#search
			width: 100%
			margin: 0 !important
			form
				margin: 1rem !important

		#nav2-1
			overflow-y: auto

	@media only screen and (min-width: 992px)
		.loggedin
			margin-left: auto

	#nav1
		background: #fff1
		@media only screen and (max-width: 991px)
			background: none
			min-height: fit-content !important
			overflow-x: hidden

	#nav2
		background: #0003
		z-index: 1
		@media only screen and (max-width: 991px)
			background: none !important
			min-height: 48vh !important
			flex-direction: column
			margin-left: auto

			a
				text-align: left
				padding: 1.2rem 0.8rem !important
			div
				width: 100% !important

	input
		background: var(--background) !important

	hr
		display: none

	#user
		margin-top: 0.1rem !important

	.loggedin
		padding: 0

	#username
		max-width: 10rem
		min-width: 1rem
		white-space: nowrap

	.offcanvas-title
		text-decoration: none

	nav
		z-index: 9
		max-height: 10vh
		

	.navbar-nav
		a
			border: none
			&:hover
				color: var(--grey-text) !important

	.offcanvas
		box-shadow: none !important

	#pfp
		background: var(--background)
		width: 2.4rem
		height: 2.4rem

	img
		width: 2.4rem
		height: 2.4rem

	.dropdown-menu
		background: var(--darker)
		border: none
		z-index: 5

	#results
		z-index: 5
		background: var(--darker)
		min-width: 25vw
		a:hover
				background: var(--accent2)

	.input-group
		width: 25vw
		max-width: 30rem
		font-size: 0.8rem
		@media only screen and (max-width: 1199px)
			width: 12rem
		@media only screen and (max-width: 991px)
			width: 100%
		button, input
			height: 2.3rem
	
	.btn
		box-shadow: none !important
</style>
