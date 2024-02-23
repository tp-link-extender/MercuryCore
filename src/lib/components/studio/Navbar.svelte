<script lang="ts">
	import { slide } from "svelte/transition"

	let search = ""
	let searchCompleted = true

	const searchResults: HTMLElement[] = []

	export let data: import("../../../routes/studio/$types").LayoutData

	const { user } = data
	const nav1 = [
		// ["Home", "/", "fa-house-chimney"],
		["Games", "/games", "fa-mountain-sun"],
		["Catalog", "/avatarshop", "fa-book-open-cover"],
		// ["Groups", "/groups", "fa-people-group"],
		["Create", "/develop", "fa-plus"],
		["Forum", "/forum", "fa-messages"]
	]
	const usernav = [
		["fa-user-group", "Friends", "/requests"],
		["fa-box-open-full", "Inventory", "/inventory"],
		["fa-user-pen", "Character", "/character"],
		["fa-gears", "Settings", "/settings"]
	]
	const searchCategories = [
		["Users", "users"],
		["Places", "places"],
		["Catalog", "assets"]
		// ["Groups", "groups"],
	]

	if (user && user.permissionLevel >= 4)
		usernav.unshift(["fa-diamond-half-stroke", "Admin", "/admin"])
</script>

<nav class="py-0 justify-start z-11">
	<div class="pt-1 px-2 sm:px-4 flex w-full pb-2px bg-[--navbar]">
		<a class="brand light-text text-xl no-underline my-auto" href="/">
			<img
				src="/icon.svg"
				alt="Mercury logo"
				class="sm:hidden size-8 @light:invert" />
			<span class="sf <sm:hidden">Mercury</span>
		</a>
		{#if user}
			<div
				class="<lg:hidden pl-6 pr-2 flex flex-row gap-4 pl-3 pt-0.19rem">
				{#each nav1 as [title, href]}
					<a class="btn px-1 light-text border-0" {href}>
						{title}
					</a>
				{/each}
			</div>
			<form
				method="POST"
				action="/search"
				role="search"
				class="mx-auto px-2 pb-1">
				<div
					class="input-group max-w-140 pt-3px xl:(absolute left-1/2 -translate-x-1/2 w-35vw) lg:w-76 md:w-100 sm:w-52">
					<input
						class="bg-background h-10 pl-4"
						name="query"
						type="search"
						placeholder="Search (ctrl+k)"
						aria-label="Search (ctrl+k)"
						autocomplete="off" />
					<button
						class="btn btn-secondary h-10 <sm:px-3 rounded-r-1.5!"
						title="Search (ctrl+k)">
						<fa fa-search />
					</button>
					{#if search.trim() && !searchCompleted}
						<div
							transition:fade={{ duration: 150 }}
							id="results"
							class="absolute flex flex-col bg-darker p-2 mt-12 rounded-3 z-5 min-w-25vw">
							{#each searchCategories as [name, category], num}
								<a
									bind:this={searchResults[num]}
									class="btn light-text py-2 text-start"
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
			<div class="flex items-center gap-4">
				<a
					href="/notifications"
					role="button"
					aria-label="Notifications"
					class="<lg:hidden font-bold pr-4 light-text">
					<fa fa-bell />
				</a>
				<a
					href="/transactions"
					role="button"
					aria-label="Transactions"
					class="flex items-center no-underline <sm:w-20 text-emerald-6 hover:text-emerald-8!">
					<fa fa-gem class="pr-2" />
					{user.currency}
				</a>
				<div class="dropdown dropdown-hover dropdown-end pl-2">
					<User
						{user}
						class="<sm:hidden"
						thin
						bg="background"
						size="2.4rem"
						full />
					<User
						{user}
						class="sm:hidden"
						thin
						bg="background"
						size="2.4rem" />
					<div class="dropdown-content pt-2">
						<ul class="p-2 rounded-3">
							{#each usernav as [icon, title, href]}
								<li class="rounded-2">
									<a class="btn light-text pl-4 pr-0" {href}>
										<fa class="{icon} pr-2" />
										{title}
									</a>
								</li>
							{/each}
							<li class="rounded-2">
								<form method="POST" action="/api?/logout">
									<button class="btn text-red-5 pl-4 pr-0">
										<fa
											fa-arrow-right-from-bracket
											class="pr-2" />
										<b>Log out</b>
									</button>
								</form>
							</li>
						</ul>
					</div>
				</div>
			</div>
		{:else}
			<div class="flex w-full gap-4 justify-end items-center py-1">
				<a href="/login" class="btn btn-secondary py-2">Log in</a>
				<a href="/register" class="btn btn-primary py-2">Register</a>
			</div>
		{/if}
	</div>
</nav>

{#if data.banners && user}
	{#each data.banners as banner (banner.id)}
		<div
			transition:slide
			class="py-1 text-center {banner.textLight
				? 'text-white'
				: 'text-black'}"
			role="alert"
			style="background: {banner.bgColour}">
			{banner.body}
		</div>
	{/each}
{/if}

{#if user}
	<nav
		id="bottomnav"
		class="lg:hidden fixed bottom-0 bg-darker w-full h-14 sm:h-16 z-11">
		<div class="flex justify-evenly mx-auto w-full sm:w-1/2">
			{#each [...nav1, ["Notifications", "/notifications", "fa-bell"]] as [title, href, icon]}
				<a
					{href}
					class="btn light-text border-0 flex flex-col items-center text-0.9rem px-0.2rem sm:(text-base px-2)">
					<fa class="{icon} pb-1 text-1.2rem sm:text-1.5rem" />
					{title}
				</a>
			{/each}
		</div>
	</nav>
{/if}

<style lang="stylus">
	#bottomnav
		border-top 1px solid var(--accent)

		box-shadow 0 0 1rem 0.2rem black

	#results
		a:hover
			background var(--accent)

		:global(.pseudofocus)
			color var(--grey-text) !important
			background var(--accent)
</style>
