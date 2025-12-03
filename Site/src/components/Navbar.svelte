<script lang="ts">
	import { untrack } from "svelte"
	import { slide } from "svelte/transition"
	import { enhance } from "$app/forms"
	import Search from "$components/Search.svelte"
	import User from "$components/User.svelte"

	const { data }: { data: import("../routes/$types").LayoutData } = $props()

	let { user } = $derived(data)

	let nav1: [string, string, string][] = $state([])
	$effect(() => {
		nav1 = [
			// ["Home", "/", "fa-house-chimney"],
			["Games", "/games", "fa-mountain-sun"],
			["Catalog", "/catalog", "fa-book-open-cover"],
			["Create", "/develop", "fa-plus"]
		]
		untrack(() => {
			if (data.pages.includes("Forum"))
				nav1.push(["Forum", "/forum", "fa-messages"])
			if (data.pages.includes("Groups"))
				nav1.push(["Groups", "/groups", "fa-people-group"])
		})
	})

	// sing, sing, sing (https://www.youtube.com/watch?v=c0pJzW8pxWU)
	let usernav: [string, string, string][] = $state([])

	$effect(() => {
		usernav = [
			["fa-money-bill-transfer", "Economy", "/economy"],
			["fa-user-group", "Friends", "/requests"],
			["fa-box-open-full", "Inventory", "/inventory"],
			["fa-user-pen", "Character", "/character"],
			["fa-gears", "Settings", "/settings"]
		]
		untrack(() => {
			// have fun with your infinite effect loops lmaooo
			// "Why is my Mercury Core suddenly running really slow?"
			if (user && user.permissionLevel >= 4)
				usernav.unshift(["fa-diamond-half-stroke", "Admin", "/admin"])
		})
	})
</script>

<nav class="py-0 justify-start z-11">
	<div
		class="bg-a pt-1 px-2 sm:px-4 flex items-center w-full lg:pb-2px h-13.5">
		<a class="light-text text-xl no-underline <sm:hidden fw-500" href="/">
			{data.siteName}
		</a>
		<a class="light-text text-xl no-underline sm:hidden" href="/">
			<img
				src="/assets/icon"
				alt="{data.siteName} logo"
				class=" size-8" />
		</a>
		{#if user}
			<div class="<lg:hidden pl-6 pr-2 flex flex-row pl-3">
				{#each nav1 as [title, href]}
					<a class="btn light-text border-0" {href}>
						{title}
					</a>
				{/each}
			</div>
			<Search pages={data.pages} />
			<div class="flex items-center gap-6">
				<a
					href="/notifications"
					aria-label="Notifications"
					class="tooltip <lg:hidden font-bold light-text">
					<fa fa-bell></fa>
				</a>
				<div class="dropdown">
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
										<fa class="{icon} pr-2"></fa>
										{title}
									</a>
								</li>
							{/each}
							<li class="rounded-2">
								<form
									use:enhance
									method="post"
									action="/api?/logout">
									<button class="btn text-red-500 pl-4 pr-0">
										<fa
											fa-arrow-right-from-bracket
											class="pr-2">
										</fa>
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
			class="py-1 text-center"
			role="alert"
			style="background: {banner.bgColour}">
			<p class="p-0 {banner.textLight ? 'text-white' : 'text-black'}">
				{banner.body}
			</p>
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
					<fa class="{icon} pb-1 text-1.2rem sm:text-1.5rem"></fa>
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
</style>
