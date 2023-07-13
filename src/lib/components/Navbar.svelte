<script lang="ts">
	import { goto } from "$app/navigation"
	import { quadOut } from "svelte/easing"

	let search = ""

	const height = (_: HTMLElement) => ({
		duration: 300,
		css: (t: number) => `
			height: ${2 * quadOut(t)}rem;
			overflow: hidden;
		`,
	})

	export let data: import("../../routes/$types").LayoutData
	const { user } = data
</script>

<nav class="navbar navbar-expand-lg navbar-dark py-0">
	<div class="d-flex">
		<button
			class="navbar-toggler mx-2 my-1"
			type="button"
			title="Open sidebar"
			data-bs-toggle="offcanvas"
			data-bs-target="#offcanvasNavbar-expand-lg"
			aria-controls="offcanvasNavbar-expand-lg">
			<span
				class="navbar-toggler-icon"
				data-bs-target="#offcanvasNavbar-expand-lg" />
		</button>
		<a class="navbar-brand light-text mx-4 mt-1 mobile-brand" href="/">
			Mercury
		</a>
	</div>
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
			<a
				id="nav-brand-1"
				class="navbar-brand light-text me-4 mt-1"
				href="/">
				Mercury
			</a>
			{#if user}
				<div class="row">
					<div class="col-6">
						<div class="navbar-nav">
							<a
								class="btn mt-1 px-1 light-text nav-item"
								href="/">
								Home
							</a>
							<a
								class="btn mt-1 px-1 light-text nav-item"
								href="/games">
								Games
							</a>
							<a
								class="btn mt-1 px-1 light-text nav-item"
								href="/avatarshop">
								Catalog
							</a>
							<!-- <a class="btn mt-1 px-1 light-text nav-item" href="/groups">Groups</a> -->
							<a
								class="btn mt-1 px-1 light-text nav-item"
								href="/forum">
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
							<a
								class="light-text mt-1 btn nav-item px-1"
								href="/avatar">
								Avatar
							</a>
							<a
								class="light-text mt-1 btn nav-item px-1"
								href="/develop">
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
								class="form-control valid bg-background"
								name="query"
								type="search"
								placeholder="Search"
								aria-label="Search" />
							<button
								on:click|preventDefault={() =>
									search
										? goto(`/search?q=${search}&c=users`)
										: null}
								class="btn btn-success py-0"
								title="Search">
								<i class="fa fa-search" />
							</button>
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
					<li class="ms-3 pt-1">
						<a
							href="/notifications"
							role="button"
							aria-label="Notifications"
							class="fw-bold nav-link me-1">
							<i class="fa fa-bell light-text" />
						</a>
					</li>
					<li class="me-2 pt-1">
						<a
							href="/transactions/your"
							role="button"
							aria-label="Transactions"
							class="nav-link text-success">
							<i class="fa fa-gem me-1 text-success" />
							<span class="h6 text-success">
								{user.currency}
							</span>
						</a>
					</li>

					<li class="dropdown2 dropdown-hover dropdown-end">
						<a href="/user/{user.number}" class="btn p-0 d-flex">
							<div
								id="pfp"
								class="mx-2 rounded-circle bg-background">
								<img
									src="/api/avatar/{user?.username}"
									alt="You"
									class="rounded-circle rounded-top-0" />
							</div>
							<p
								id="username"
								class="my-auto fs-6 me-2 light-text">
								{user?.username}
							</p>
						</a>
						<div class="dropdown-content pt-2">
							<ul class="py-2 rounded-3">
								<li>
									<a
										class="btn light-text py-2"
										href="/settings">
										<i class="fa fa-gears me-2" />
										Settings
									</a>
								</li>
								<li>
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
		{#if user}
			<nav id="nav2" class="navbar navbar-dark px-4 py-0 w-100">
				<div id="nav2-2" class="navbar-nav w-50">
					<a
						class="light-text btn nav-item m-0 py-1"
						href="/user/{user.number}">
						Profile
					</a>
					<a
						class="light-text btn nav-item m-0 py-1"
						href="/inventory">
						Inventory
					</a>
					<a
						class="light-text btn nav-item m-0 py-1"
						href="/requests">
						Friends
					</a>
					<a class="light-text btn nav-item m-0 py-1" href="/avatar">
						Avatar
					</a>
					<a class="light-text btn nav-item m-0 py-1" href="/develop">
						Develop
					</a>
				</div>
			</nav>
		{/if}
	</div>
</nav>

{#if data.banners && user}
	{#each data.banners as announcement (announcement.id)}
		<div
			transition:height
			class="py-1 my-0 rounded-0 text-center border-0 text-{announcement.textLight
				? 'light'
				: ''}"
			role="alert"
			style="background: {announcement.bgColour}">
			{announcement.body}
		</div>
	{/each}
{/if}

<style lang="stylus">
	.mobile-brand
		display none

	+-lg()
		.offcanvas-header
			background var(--accent)
		.offcanvas
			background var(--background)
		.offcanvas-body
			background var(--background)
			min-height 100vh
			flex-direction column-reverse
			justify-content start
			padding-top 1rem !important

			a
				margin-bottom 1rem
				width 100%
				text-align start

		.loggedin
			margin-bottom 1rem
			order 1

		.mobile-brand
			display block

		#nav-brand-1
			display none

		#search
			width 100%
			margin 0 !important
			form
				margin 1rem !important

		#nav2-1
			display block
			overflow-x none

		#nav2
			display none

		.mobilenav
			display block

	+lg()
		.loggedin
			margin-left auto

		#nav2-1
			display none

		.mobilenav
			display none

	#nav1
		// padding-top 1px
		background #fff1
		+-lg()
			background none
			min-height fit-content !important
			overflow-x hidden

	#nav2
		background #0003
		z-index 1
		+-lg()
			background none !important
			min-height 36vh !important
			flex-direction column
			margin-left auto

			a
				text-align left
				padding 1.2rem 0.8rem !important
			div
				width 100% !important

	.loggedin
		padding 0

	#username
		max-width 10rem
		min-width 1rem
		white-space nowrap

	.offcanvas-title
		text-decoration none

	nav
		z-index 9
		max-height 10vh

	.navbar-nav
		a
			border none
			&:hover
				color var(--grey-text) !important

	.offcanvas
		box-shadow none !important

	#pfp
	img
		width 2.4rem
		height 2.4rem

	#results
		z-index 5
		min-width 25vw
		a:hover
			background var(--accent2)

	.input-group
		width 25vw
		max-width 30rem
		font-size 0.8rem
		+-xl()
			width 12rem
		+-lg()
			width 100%

		button
		input
			height 2.3rem

	.btn
		box-shadow none !important
</style>
