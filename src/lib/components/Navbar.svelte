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

	const { user } = data
	const nav1 = [
		// ["Home", "/", "fa-house-chimney"],
		["Games", "/games", "fa-mountain-sun"],
		["Catalog", "/avatarshop", "fa-book-open-cover"],
		// ["Groups", "/groups", "fa-people-group"],
		["Create", "/develop", "fa-plus"],
		["Forum", "/forum", "fa-messages"],
	]
	const usernav = [
		["fa-user-group", "Friends", "/requests"],
		["fa-box-open-full", "Inventory", "/inventory"],
		["fa-user-pen", "Character", "/character"],
		["fa-gears", "Settings", "/settings"],
	]
	const searchCategories = [
		["Users", "users"],
		["Places", "places"],
		["Catalog", "assets"],
		// ["Groups", "groups"],
	]

	if (user && user.permissionLevel >= 4)
		usernav.unshift(["fa-diamond-half-stroke", "Admin", "/admin"])
</script>

<nav class="py-0 justify-content-start">
	<div id="nav1" class="pt-1 d-flex w-100">
		<a class="brand light-text fs-5 text-decoration-none my-auto" href="/">
			<img src="/icon.svg" alt="Mercury logo" />
			<span>Mercury</span>
		</a>
		{#if user}
			<div id="topnav" class="row ps-6 pe-2">
				<div class="d-flex flex-row gap-4 ps-3" id="topnavitems">
					{#each nav1 as [title, href]}
						<a class="btn px-1 light-text border-0" {href}>
							{title}
						</a>
					{/each}
				</div>
			</div>
			<div class="mx-auto px-2">
				<form use:enhance method="POST" action="/search" role="search">
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
												? searchCategories.length - 1
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
								search.trim()
									? goto(`/search?q=${search.trim()}&c=users`)
									: null

								searchCompleted = true
							}}
							class="btn btn-success py-0 rounded-end-2"
							title="Search">
							<fa fa-search />
						</button>
						{#if search.trim() && !searchCompleted}
							<div
								transition:fade={{ duration: 150 }}
								id="results"
								class="position-absolute d-flex flex-column bg-darker p-2 mt-12 rounded-3">
								{#each searchCategories as [name, category], num}
									<a
										bind:this={searchResults[num]}
										class="btn text-start light-text py-2"
										href="/search?q={search.trim()}&c={category}"
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
			<div class="d-flex align-items-center gap-4">
				<a
					id="notificationstop"
					href="/notifications"
					role="button"
					aria-label="Notifications"
					class="font-bold pe-4">
					<fa fa-bell class="light-text" />
				</a>
				<a
					id="transactionsbutton"
					href="/transactions"
					role="button"
					aria-label="Transactions"
					class="text-success d-flex align-items-center
					text-decoration-none">
					<fa fa-gem class="pe-2 text-success" />
					<span class="fs-6 text-success">
						{user.currency}
					</span>
				</a>
				<div class="dropdown dropdown-hover dropdown-end ps-2">
					<User {user} full thin bg="background" size="2.4rem" />
					<div class="dropdown-content pt-2">
						<ul class="p-2 rounded-3">
							{#each usernav as [icon, title, href]}
								<li class="rounded-2">
									<a
										class="btn light-text ps-4 pe-0 text-start"
										{href}>
										<fa class="{icon} pe-2" />
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
											class="fa fa-arrow-right-from-bracket pe-2" />
										<b>Log out</b>
									</button>
								</form>
							</li>
						</ul>
					</div>
				</div>
			</div>
		{:else}
			<div
				class="d-flex w-100 gap-4 justify-content-end align-items-center">
				<a href="/login" class="btn light-text">Log in</a>
				<a href="/register" class="btn btn-success">Register</a>
			</div>
		{/if}
	</div>
</nav>

{#if data.banners && user}
	{#each data.banners as banner (banner.id)}
		<div
			transition:height
			class="py-1 text-center"
			class:text-light={banner.textLight}
			role="alert"
			style="background: {banner.bgColour}">
			{banner.body}
		</div>
	{/each}
{/if}

{#if user}
	<nav id="bottomnav" class="position-fixed bottom-0 bg-darker w-100">
		<div class="d-flex justify-content-evenly mx-auto">
			{#each nav1 as [title, href, icon]}
				<a {href} class="btn light-text border-0 d-flex flex-column">
					<fa class="{icon} pb-1" />
					{title}
				</a>
			{/each}
			<a
				href="/notifications"
				id="notificationsbottom"
				class="btn light-text border-0 flex-column">
				<fa fa-bell class="pb-1" />
				Notifications
			</a>
		</div>
	</nav>
{/if}

<style lang="stylus">
	nav
		z-index 9
		flex-wrap nowrap

	#nav1
		padding-left 1rem
		padding-right 1rem
		padding-bottom 2px

	#bottomnav
	#notificationsbottom
		display none

	.brand img
		height 2rem !important
		display none

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
		fa
			font-size 1.5rem

	+lightTheme()
		.brand img
			filter invert(1)

	+-lg()
		#bottomnav
			display block
		#topnav
		#notificationstop
			display none
		#notificationsbottom
			display flex

	+-sm()
		#nav1
			padding-left 0.5rem
			padding-right 0.5rem
		.brand
			img
				margin-top -0.2rem
				width 2rem
				height 2rem
				display block

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
			fa
				font-size 1.2rem

		#transactionsbutton
			width 5rem

	#nav1
		background #fff1
		+lightTheme()
			background #0003

	.dropdown
		margin-bottom 2px

	#topnav
		z-index 9
		max-height 10vh

	#topnavitems
		margin-top 0.19rem

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
