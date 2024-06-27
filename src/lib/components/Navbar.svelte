<script lang="ts">
	import { enhance } from "$app/forms"
	import { goto } from "$app/navigation"
	import fade from "$lib/fade"
	import { slide } from "svelte/transition"
	import User from "./User.svelte"

	let search = ""
	let searchCompleted = true
	let currentSearchFocus = -1

	$: if (search === "") {
		searchCompleted = true
		currentSearchFocus = -1
	}

	let searchInput: HTMLInputElement
	const searchResults: HTMLElement[] = []

	function keydown(
		e: KeyboardEvent & {
			currentTarget: EventTarget & HTMLInputElement
		}
	) {
		switch (e.key) {
			case "Enter":
				if (!searchCompleted && currentSearchFocus >= 0) {
					e.preventDefault()
					searchResults[currentSearchFocus].click()
				}

				searchCompleted = true
				currentSearchFocus = -1
				break
			case "ArrowDown":
			case "ArrowUp": {
				e.preventDefault()

				// Focus first result
				const prevSearchFocus = currentSearchFocus

				currentSearchFocus += e.key === "ArrowDown" ? 1 : -1
				currentSearchFocus =
					currentSearchFocus >= searchCategories.length
						? 0
						: currentSearchFocus < 0
							? searchCategories.length - 1
							: currentSearchFocus

				searchResults[currentSearchFocus]?.classList.add("pseudofocus")
				searchResults[prevSearchFocus]?.classList.remove("pseudofocus")

				break
			}
			case "Escape":
				search = ""
				break
			default:
				searchCompleted = false
		}
	}

	export let data: import("../../routes/$types").LayoutData

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
		["fa-money-bill-transfer", "Economy", "/economy"],
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

<svelte:window
	on:keydown={e => {
		// the right way (actually works on different keyboard layouts)
		if (e.ctrlKey && e.key === "k") {
			e.preventDefault()
			searchInput.focus()
		}
	}} />

<nav class="py-0 justify-start z-11">
	<div class="pt-1 px-2 sm:px-4 flex w-full pb-2px bg-[--navbar]">
		<a class="brand light-text text-xl no-underline my-auto" href="/">
			<img src="/icon.svg" alt="Mercury logo" class="sm:hidden size-8" />
			<span class="<sm:hidden fw-300">Mercury</span>
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
				use:enhance
				method="POST"
				action="/search"
				role="search"
				class="mx-auto px-2 pb-1">
				<div
					class="input-group max-w-140 pt-3px xl:(absolute left-1/2 -translate-x-1/2 w-35vw) lg:w-76 md:w-100 sm:w-52">
					<input
						bind:this={searchInput}
						bind:value={search}
						on:keydown={keydown}
						class="bg-background h-10 pl-4"
						name="query"
						type="search"
						placeholder="Search (ctrl+k)"
						aria-label="Search (ctrl+k)"
						autocomplete="off" />
					<button
						on:click|preventDefault={() => {
							if (search.trim())
								goto(`/search?q=${search.trim()}&c=users`)
							searchCompleted = true
						}}
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
			<div class="flex items-center gap-6">
				<a
					href="/notifications"
					aria-label="Notifications"
					class="tooltip <lg:hidden font-bold light-text">
					<fa fa-bell />
				</a>
				<div class="dropdown dropdown-hover dropdown-end">
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
								<form
									use:enhance
									method="POST"
									action="/api?/logout">
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

<style>
	#bottomnav {
		border-top: 1px solid var(--accent);
		box-shadow: 0 0 1rem 0.2rem #000;
	}

	#results {
		& a:hover {
			background: var(--accent);
		}
		& :global(.pseudofocus) {
			color: var(--grey-text) !important;
			background: var(--accent);
		}
	}
</style>
