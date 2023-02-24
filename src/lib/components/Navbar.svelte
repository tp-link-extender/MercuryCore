<script lang="ts">
	import { enhance } from "$app/forms"
	import { goto } from "$app/navigation"
	import { onMount } from "svelte"
	import { fade } from "svelte/transition"
	import { getUser } from "@lucia-auth/sveltekit/client"

	let search = ""

	const user = getUser()
	export let data: any

	$: timer = $user?.currencyCollected.getTime() - (new Date().getTime() - 1000 * 3600 * data.stipendTime)
	$: seconds = Math.floor((timer / 1000) % 60)
		.toString()
		.padStart(2, "0")
	$: minutes = Math.floor((timer / 1000 / 60) % 60)
		.toString()
		.padStart(2, "0")
	$: hours = Math.floor((timer / 1000 / 3600) % 24)
		.toString()
		.padStart(2, "0")

	onMount(() => {
		function animationInterval(ms: number, callback: (time: number) => void) {
			const start: any = document.timeline.currentTime

			function frame(time: number) {
				callback(time)
				scheduleFrame(time)
			}
			function scheduleFrame(time: number) {
				const elapsed = time - start
				const roundedElapsed = Math.round(elapsed / ms) * ms
				const targetNext = start + roundedElapsed + ms
				const delay = targetNext - performance.now()
				setTimeout(() => requestAnimationFrame(frame), delay)
			}
			scheduleFrame(start)
		}
		animationInterval(1000, () => (timer -= 1000))
	})
</script>

<nav class="navbar navbar-expand-lg navbar-dark position-fixed w-100 px-4 py-1">
	<a class="navbar-brand light-text me-5" href="/">Mercury</a>
	<button class="navbar-toggler" type="button" title="Open sidebar" data-bs-toggle="offcanvas" data-bs-target="#offcanvasNavbar-expand-lg" aria-controls="offcanvasNavbar-expand-lg">
		<span class="navbar-toggler-icon" data-bs-target="#offcanvasNavbar-expand-lg" />
	</button>
	<div class="offcanvas offcanvas-start border-0 text-bg-dark" data-bs-hideresize="true" tabindex="-1" id="offcanvasNavbar-expand-lg" aria-labelledby="offcanvasNavbar-expand-lg">
		<div class="offcanvas-header">
			<a href="/" class="offcanvas-title light-text h5">Mercury</a>
			<button type="button" class="btn-close btn-close-white text-reset me-1" data-bs-dismiss="offcanvas" aria-label="Close" />
		</div>
		<div class="offcanvas-body d-flex">
			{#if $user}
				<div class="navbar-nav">
					<a href="/games" class="nav-link mt-1 shadow-none mr-0 light-text nav-item">Games</a>
					<a href="/avatarshop" class="nav-link mt-1 shadow-none mr-0 light-text nav-item">Avatar Shop</a>
					<a href="/groups" class="nav-link mt-1 shadow-none mr-0 light-text nav-item">Groups</a>
					{#if $user?.permissionLevel == "Administrator"}
						<a href="/admin" class="nav-link mt-1 shadow-none mr-0 light-text nav-item">Admin</a>
					{/if}
				</div>
				<div id="search" class="navbar-nav ms-4 me-auto">
					<form use:enhance method="POST" action="/search" class="my-1 w-auto" role="search">
						<div class="input-group">
							<input bind:value={search} class="form-control valid" name="query" type="search" placeholder="Search" aria-label="Search" />
							<button on:click|preventDefault={() => (search ? goto(`/search?q=${search}&c=users`) : null)} class="btn btn-success py-0" type="submit" title="Search"
								><i class="fa fa-search" /></button
							>
						</div>
						{#if search}
							<div transition:fade={{ duration: 150 }} id="results" class="position-absolute card p-2 mt-2">
								<a class="btn text-start light-text py-2" href="/search?q={search}&c=users" title="Search Users">Search <b>{search}</b> in Users</a>
								<a class="btn text-start light-text py-2" href="/search?q={search}&c=places" title="Search Places">Search <b>{search}</b> in Places</a>
								<a class="btn text-start light-text py-2" href="/search?q={search}&c=items" title="Search Avatar shop">Search <b>{search}</b> in Avatar shop</a>
								<a class="btn text-start light-text py-2" href="/search?q={search}&c=groups" title="Search Groups">Search <b>{search}</b> in Groups</a>
							</div>
						{/if}
					</form>
				</div>
				<ul class="navbar-nav loggedin m-0">
					<li class="dropdown">
						<a id="rocks" href="/transactions" role="button" data-bs-toggle="dropdown" aria-expanded="false" class="fw-bold nav-link mt-1 text-success shadow-none">
							<i class="fa fa-gem me-1" />
							<span class="h6 text-success">
								{$user.currency}
							</span>
						</a>

						<ul class="dropdown-menu mt-2">
							<li><h6 class="dropdown-header grey-text">CURRENCY</h6></li>
							<li>
								<form use:enhance method="POST" action="/api?/stipend">
									<button type="submit" class="dropdown-item text-light {timer > 0 ? 'disabled' : ''}"
										><i class="fa fa-money-bills me-2" />
										{#if timer > 0}
											{hours}:{minutes}:{seconds}
										{:else}
											Get Stipend
										{/if}
									</button>
								</form>
							</li>
							<li><a class="dropdown-item light-text" href="/transactions"><i class="fa fa-coins me-2" /> Transactions</a></li>
						</ul>
					</li>
					<li class="dropdown ms-2">
						<a href="/user/{$user.number}" role="button" data-bs-toggle="dropdown" aria-expanded="false" class="d-flex text-decoration-none mb-1 light-text">
							<div id="pfp" class="mx-2 rounded-circle">
								<img src={$user?.image} alt="You" class="rounded-circle rounded-top-0" />
							</div>
							<p id="displayname" class="light-text my-auto fs-6">
								{$user?.displayname}
							</p>
							<i class="fa fa-ellipsis-vertical ms-2 my-auto fs-6 me-4" />
						</a>

						<ul class="dropdown-menu mt-2">
							<li><h6 class="dropdown-header grey-text">ACCOUNT</h6></li>
							<li><a class="dropdown-item light-text" href="/user/{$user.number}"><i class="fa fa-address-card me-2" /> Profile</a></li>
							<li><a class="dropdown-item light-text" href="/inventory"><i class="fa fa-box-open me-2" /> Inventory</a></li>
							<li><a class="dropdown-item light-text" href="/requests"><i class="fa fa-user-plus me-2" /> Friend requests</a></li>
							<li><a class="dropdown-item light-text" href="/user/{$user.number}"><i class="fa fa-user-pen me-2" /> Avatar</a></li>
							<li><a class="dropdown-item light-text" href="/user/{$user.number}"><i class="fa fa-users me-2" /> My Groups</a></li>
							<li><hr class="dropdown-divider" /></li>
							<li><a class="dropdown-item light-text" href="/settings"><i class="fa fa-gears me-2" /> Settings</a></li>
							<li>
								<form use:enhance method="POST" action="/api?/logout">
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
</nav>

<style lang="sass">
	@media only screen and (max-width: 991px)
		.offcanvas-header
			background: var(--accent)
		.offcanvas-body
			background: var(--background)
			min-height: 100vh
			flex-direction: column-reverse
			justify-content: start

			a
				margin-bottom: 1rem
				width: 100%
				text-align: start

			.loggedin
				margin-bottom: 1rem
		
		#search
			width: 100%
			margin: 0  !important
			form
				margin: 1rem !important

	@media only screen and (min-width: 992px)
		.loggedin
			margin-left: auto

	.loggedin
		padding: 0

	#displayname
		max-width: 10rem
		min-width: 1rem
		overflow: hidden
		text-overflow: ellipsis
		white-space: nowrap

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
		z-index: 1
		background: var(--darker)
		min-width: 15rem
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
</style>
