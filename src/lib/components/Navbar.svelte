<script lang="ts">
	import { goto } from "$app/navigation"
	import { quadOut } from "svelte/easing"

	let search = "",
		searchCompleted = true,
		currentSearchFocus = -1

	$: if (search == "") {
		searchCompleted = true
		currentSearchFocus = -1
	}

	const height = (_: HTMLElement) => ({
			duration: 300,
			css: (t: number) => `
				height: ${2 * quadOut(t)}rem;
				overflow: hidden;
			`,
		}),
		searchResults: HTMLElement[] = []

	export let data: import("../../routes/$types").LayoutData

	const { user } = data,
		nav1 = [
			// ["Home", "/", "fa-house-chimney"],
			["Games", "/games", "fa-mountain-sun"],
			["Catalog", "/avatarshop", "fa-book-open-cover"],
			// ["Groups", "/groups", "fa-people-group"],
			["Create", "/develop", "fa-plus"],
			["Forum", "/forum", "fa-messages"],
		],
		usernav = [
			["fa-user-group", "Friends", "/requests"],
			["fa-box-open-full", "Inventory", "/inventory"],
			["fa-user-pen", "Avatar", "/avatar"],
			["fa-gears", "Settings", "/settings"],
		],
		searchCategories = [
			["Users", "users"],
			["Places", "places"],
			["Catalog", "assets"],
			// ["Groups", "groups"],
		]

	if (user && user.permissionLevel >= 4)
		usernav.unshift(["fa-diamond-half-stroke", "Admin", "/admin"])
</script>

<nav class="navbar navbar-expand-lg navbar-dark py-0">
	<a class="navbar-brand light-text mx-4 mobile-brand" href="/">Mercury</a>
	<button
		class="navbar-toggler ms-auto my-1 me-3"
		type="button"
		title="Open sidebar"
		data-bs-toggle="offcanvas"
		data-bs-target="#offcanvasNavbar-expand-lg"
		aria-controls="offcanvasNavbar-expand-lg">
		<span
			class="navbar-toggler-icon"
			data-bs-target="#offcanvasNavbar-expand-lg" />
	</button>
	<div
		class="offcanvas offcanvas-start border-0"
		data-bs-hideresize="true"
		tabindex="-1"
		id="offcanvasNavbar-expand-lg"
		aria-labelledby="offcanvasNavbar-expand-lg">
		<div class="offcanvas-header">
			<a href="/" class="offcanvas-title light-text h5">Mercury</a>
			<button
				type="button"
				class="btn-close btn-close-white text-reset me-1"
				data-bs-dismiss="offcanvas"
				aria-label="Close" />
		</div>

		<div id="nav1" class="offcanvas-body px-4 py-1 d-flex">
			<a id="nav-brand-1" class="navbar-brand light-text me-4 mt-1" href="/">Mercury</a>
			{#if user}
			<div class="row">
				<div class="col-6">
				<div class="navbar-nav">
					<a class="btn mt-1 px-1 light-text nav-item" href="/">
						Home
					</a>
					<a class="btn mt-1 px-1 light-text nav-item" href="/games">
						Games
					</a>
					<a
						class="btn mt-1 px-1 light-text nav-item"
						href="/avatarshop">
					    Catalog
					</a>
					<!-- <a class="btn mt-1 px-1 light-text nav-item" href="/groups">Groups</a> -->
					<a class="btn mt-1 px-1 light-text nav-item" href="/forum">
						Forum
					</a>
					{#if user?.permissionLevel >= 4}
						<a
							class="btn mt-1 px-1 light-text nav-item"
							href="/admin">
							Admin
						</a>
					{/if}
				</div>

			</div>
			<div class="col-6 mobilenav">
				<div id="nav2-1" class="navbar-nav w-100">
					<a
						class="light-text mt-1 btn nav-item px-1"
						href="/user/{user.number}">
						Profile
					</a>
					<a
						class="light-text mt-1 btn nav-item px-1"
						href="/inventory">
						Inventory
					</a>
					<a
						class="light-text mt-1 btn nav-item px-1"
						href="/requests">
						Friends
					</a>
					<a class="light-text mt-1 btn nav-item px-1" href="/avatar">
						Avatar
					</a>
					<a class="light-text mt-1 btn nav-item px-1" href="/develop">
						Develop
					</a>
				</div>
			</div>
			</div>
				<div id="search" class="navbar-nav ms-4 me-auto mt-1">
					<form
						use:enhance
						method="POST"
						action="/search"
						class="w-auto"
						role="search">
						<div class="input-group">
							<input
								bind:value={search}
								on:keydown={e => {
									switch (e.key) {
										case "Enter":
											if (
												!searchCompleted &&
												currentSearchFocus >= 0
											) {
												e.preventDefault()
												searchResults[
													currentSearchFocus
												].click()
											}

											searchCompleted = true
											currentSearchFocus = -1
											break
										case "ArrowDown":
										case "ArrowUp":
											e.preventDefault()

											// Focus first result
											const prevSearchFocus =
												currentSearchFocus

											currentSearchFocus +=
												e.key == "ArrowDown" ? 1 : -1

											currentSearchFocus =
												currentSearchFocus >=
												searchCategories.length
													? 0
													: currentSearchFocus < 0
													? searchCategories.length -
													  1
													: currentSearchFocus

											searchResults[
												currentSearchFocus
											]?.classList.add("pseudofocus")
											searchResults[
												prevSearchFocus
											]?.classList.remove("pseudofocus")

											break
										case "Escape":
											search = ""
											break
										default:
											searchCompleted = false
									}
								}}
								class="form-control valid bg-background"
								name="query"
								type="search"
								placeholder="Search"
								aria-label="Search"
								autocomplete="off" />
							<button
								on:click|preventDefault={() => {
									search
										? goto(`/search?q=${search}&c=users`)
										: null}
								class="btn btn-success py-0"
								type="submit"
								title="Search">
								<i class="fa fa-search" />
							</button>
							{#if search && !searchCompleted}
								<div
									transition:fade={{ duration: 150 }}
									id="results"
									class="position-absolute d-flex flex-column bg-darker p-2 mt-12 rounded-3">
									{#each searchCategories as [name, category], num}
										<a
											bind:this={searchResults[num]}
											class="btn text-start light-text py-2"
											href="/search?q={search}&c={category}"
											title="Search {name}">
											Search <b>{search}</b>
											in {name}
										</a>
									{/each}
								</div>
							{/if}
						</div>
						{#if search}
							<div
								transition:fade={{ duration: 150 }}
								id="results"
								class="position-absolute card bg-darker p-2 pe-0 mt-2">
								<a
									class="btn text-start light-text py-2"
									href="/search?q={search}&c=users"
									title="Search Users">
									Search <b>{search}</b>
									in Users
								</a>
								<a
									class="btn text-start light-text py-2"
									href="/search?q={search}&c=places"
									title="Search Places">
									Search <b>{search}</b>
									in Places
								</a>
								<a
									class="btn text-start light-text py-2"
									href="/search?q={search}&c=assets"
									title="Search Catalog">
									Search <b>{search}</b>
									in Catalog
								</a>
								<!-- <a class="btn text-start light-text py-2" href="/search?q={search}&c=groups" title="Search Groups">Search <b>{search}</b> in Groups</a> -->
							</div>
						{/if}
					</form>
				</div>
				<ul class="navbar-nav loggedin m-0">
					<li id="notificationstop" class="pt-1">
						<a
							href="/notifications"
							role="button"
							aria-label="Notifications"
							class="fw-bold nav-link me-1">
							<i class="fa fa-bell light-text" />
						</a>
					</li>
					<li id="transactionsbutton" class="pt-1">
						<a
							href="/transactions/your"
							role="button"
							aria-label="Transactions"
							class="fw-bold nav-link text-success">
							<i class="fa fa-gem me-1 text-success" />
							<span class="h6 text-success">
								{user.currency}
							</span>
						</a>
					</li>
					<li class="dropdown">
						<a
							href="/user/{user.number}"
							role="button"
							data-bs-toggle="dropdown"
							aria-expanded="false"
							class="fw-bold nav-item mx-0 text-decoration-none px-0 mb-2">
							<a
								id="user"
								href="/user/{user.number}"
								class="btn p-0 d-flex text-decoration-none light-text w-50">
								<div
									id="pfp"
									class="mx-2 rounded-circle bg-background">
									<img
										src="/api/avatar/{user?.username}"
										alt="You"
										class="rounded-circle rounded-top-0" />
								</div>
								<p id="username" class="my-auto fs-6 me-2">
									{user?.username}
								</p>
							</a>
						</a>

					<li class="dropdown2 dropdown-hover dropdown-end">
						<a
							href="/user/{user.number}"
							class="btn p-0 d-flex">
							<div
								id="pfp"
								class="mx-2 rounded-circle bg-background">
								<img
									src="/api/avatar/{user?.username}"
									alt="You"
									class="rounded-full rounded-top-0" />
							</div>
							<p id="username" class="my-auto fs-6 me-2 light-text">
								{user?.username}
							</p>
						</a>
						<div class="dropdown-content pt-2">
							<ul class="p-2 rounded-3">
								{#each usernav as [icon, title, href]}
									<li class="rounded-2">
										<a
											class="btn light-text ps-4 pe-0 text-start"
											{href}>
											<i class="fa {icon} me-2" />
											{title}
										</a>
									</li>
								{/each}
								<li class="rounded-2">
									<form
										use:enhance
										method="POST"
										action="/api?/logout">
										<button class="btn text-danger py-2">
											<i
												class="fa fa-arrow-right-from-bracket me-2" />
											<b>Log out</b>
										</button>
									</form>
								</li>
							</ul>
						</div>
					</li>
				</ul>
			{:else}
				<ul class="navbar-nav loggedin">
					<li class="nav-item mt-1">
						<a href="/login" class="btn mb-1 light-text">Log in</a>
					</li>
					<li class="nav-item mt-1">
						<a
							href="/register"
							class="btn btn-success my-2 my-sm-0">
							Register
						</a>
					</li>
				</ul>
			{/if}
		</div>
	</div>
</nav>

{#if data.banners && user}
	{#each data.banners as announcement (announcement.id)}
		<div
			transition:height|local
			class="py-1 my-0 rounded-0 text-center border-0 text-{announcement.textLight
				? 'light'
				: ''}"
			role="alert"
			style="background: {announcement.bgColour}">
			{announcement.body}
		</div>
	{/each}
{/if}

<style lang="sass">
	.mobile-brand
		display: none

	@media only screen and (max-width: 992px)
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

		.loggedin
			margin-bottom: 1rem
			order: 1

		.mobile-brand
			display: block

		#nav-brand-1
			display: none

		#user
			margin-left: 0.5rem !important
			margin-bottom: 1.5rem !important

		#search
			width: 100%
			margin: 0 !important
			form
				margin: 1rem !important

		#nav2-1
			display: block
			overflow-x: none

		#nav2
			display: none

		.mobilenav
			display: block

	@media only screen and (min-width: 992px)
		.loggedin
			margin-left: auto

		#nav2-1
			display: none
		
		.mobilenav
			display: none

	#nav1
		background: #fff1
		@media only screen and (max-width: 992px)
			background: none
			min-height: fit-content !important
			overflow-x: hidden
	

	#nav2
		background: #0003
		z-index: 1
		@media only screen and (max-width: 992px)
			background: none !important
			min-height: 36vh !important
			flex-direction: column
			margin-left: auto

			a
				text-align: left
				padding: 1.2rem 0.8rem !important
			div
				width: 100% !important

	#user
		margin-top: 0.1rem !important

	.loggedin
		margin-left auto

	nav
		z-index 9

	#bottomnav
		border-top 1px solid var(--accent)
		height 4rem

		box-shadow 0 0 1rem 0.2rem black
		+lightTheme()
			box-shadow 0 0 1rem 0.2rem white

		div
			width 50%
		a
			font-size 1rem
			padding-left 0.5rem
			padding-right 0.5rem
		i
			font-size 1.5rem
	
	+lightTheme()
		.navbar-brand img
			filter invert(1)

	+lg()
		#bottomnav
		#notificationsbottom
			display none

	+-lg()
		#topnav
		#notificationstop
			display none
		#notificationsbottom
			display flex

	+sm()
		#nav1
			padding-left 1rem
			padding-right 1rem
		.navbar-brand
			img
				display none

	+-sm()
		#nav1
			padding-left 0.5rem
			padding-right 0.5rem
		.dropdown2 p
			display none
		.navbar-brand
			img
				margin-top -0.2rem
				width 2rem
				height 2rem

			span
				display none

		#bottomnav
			height 3.5rem
			div
				width 100%
			a
				font-size 0.9rem	
				padding-left 0.2rem
				padding-right 0.2rem
			i
				font-size 1.2rem

		#transactionsbutton
			width 5rem

	#nav1
		background #fff1
		+lightTheme()
			background #0003

	.loggedin
		padding 0

	.dropdown2
		margin-top 2px
		p
			max-width 6rem
			min-width 1rem
			// ellipsis
			overflow hidden
			text-overflow ellipsis

	#topnav
		z-index 9
		max-height 10vh

	#bottomnav
	.navbar-nav
		a
			border none

	#pfp
	#pfp img
		width 2.4rem
		height 2.4rem

	.dropdown-menu
		border: none
		z-index: 5

	#results
		z-index 5
		min-width 25vw
		a:hover
			background var(--accent)

	.input-group
		width: 25vw
		max-width: 30rem
		font-size: 0.8rem
		@media only screen and (max-width: 1199px)
			width: 12rem
		@media only screen and (max-width: 992px)
			width: 100%
		button, input
			height: 2.3rem

	.btn
		box-shadow: none !important
</style>
