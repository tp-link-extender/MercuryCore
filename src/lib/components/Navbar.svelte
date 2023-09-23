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

<nav class="navbar navbar-expand py-0">
	<div class="w-100 border-0" tabindex="-1">
		<div id="nav1" class="py-1 d-flex">
			<a class="navbar-brand light-text me-0" href="/">
				<img class="me-2" src="/favicon.svg" alt="Mercury logo" />
				<span class="me-6">Mercury</span>
			</a>
			{#if user}
				<div id="topnav" class="row me-2">
					<div class="navbar-nav ms-3">
						{#each nav1 as [title, href]}
							<a class="btn mt-1 px-1 light-text nav-item" {href}>
								{title}
							</a>
						{/each}
					</div>
				</div>
				<div class="navbar-nav mx-auto">
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
										: null

									searchCompleted = true
								}}
								class="btn btn-success py-0 rounded-end-2"
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
					</form>
				</div>
				<ul class="navbar-nav m-0">
					<li id="notificationstop" class="pt-1">
						<a
							href="/notifications"
							role="button"
							aria-label="Notifications"
							class="font-bold nav-link me-1">
							<i class="fa fa-bell light-text" />
						</a>
					</li>
					<li id="transactionsbutton" class="my-auto">
						<a
							href="/transactions/your"
							role="button"
							aria-label="Transactions"
							class="nav-link text-success">
							<i class="fa fa-gem me-1 text-success" />
							<span class="fs-6 text-success">
								{user.currency}
							</span>
						</a>
					</li>

					<li class="dropdown dropdown-hover dropdown-end ps-2">
						<User {user} full thin bg="background" size="2.4rem" />
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
										<button
											class="btn text-danger ps-4 pe-0 text-start">
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
				<ul
					class="navbar-nav d-flex w-100 justify-content-end align-items-center">
					<li class="nav-item">
						<a href="/login" class="btn mb-1 light-text">Log in</a>
					</li>
					<li class="nav-item">
						<a href="/register" class="btn btn-success">Register</a>
					</li>
				</ul>
			{/if}
		</div>
	</div>
</nav>

{#if data.banners && user}
	{#each data.banners as banner (banner.id)}
		<div
			transition:height
			class="py-1 my-0 rounded-0 text-center border-0"
			class:text-light={banner.textLight}
			role="alert"
			style="background: {banner.bgColour}">
			{banner.body}
		</div>
	{/each}
{/if}

{#if user}
	<nav id="bottomnav" class="position-fixed bottom-0 bg-darker w-100">
		<div class="d-flex flex-row justify-content-evenly mx-auto">
			{#each nav1 as [title, href, icon]}
				<a {href} class="btn light-text nav-item d-flex flex-column">
					<i class="fa {icon} mb-1" />
					{title}
				</a>
			{/each}
			<a
				href="/notifications"
				id="notificationsbottom"
				class="btn light-text nav-item flex-column">
				<i class="fa fa-bell mb-1" />
				Notifications
			</a>
		</div>
	</nav>
{/if}

<style lang="stylus">
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

	.dropdown
		margin-top 2px

	#topnav
		z-index 9
		max-height 10vh

	#bottomnav
	.navbar-nav
		a
			border none

	#results
		z-index 5
		min-width 25vw
		a:hover
			background var(--accent)

		:global(.pseudofocus)
			color var(--grey-text) !important
			background var(--accent)

	.input-group
		width 35vw
		max-width 35rem
		margin-top 2px

		+xl()
			position absolute
			left 50%
			transform translateX(-50%)
		+-xl()
			width 19rem
		+-lg()
			width 25rem
		+-md()
			width 13rem
		+-sm()
			width 100%

		button
		input
			height 2.3rem
</style>
