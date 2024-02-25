<script lang="ts">
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

	if (user && user.permissionLevel >= 4)
		usernav.unshift(["fa-diamond-half-stroke", "Admin", "/admin"])
</script>

<svelte:head>
	<script>
		$(document).ready(function () {
			$("#hover").hover(
				function () {
					$("#dropdown").show()
				},
				function () {
					$("#dropdown").hide()
				}
			)
		})
	</script>
</svelte:head>

<nav class="py-0 justify-start z-11">
	<div
		class="pt-1 px-2 sm:px-4 flex w-full pb-2px"
		style="background: #201f1e">
		<a
			class="brand light-text float-left text-xl no-underline pt-2"
			href="/">
			<img src="/icon.svg" alt="Mercury logo" class="sm:hidden size-8" />
			<span class="sf <sm:hidden pr-3">Mercury</span>
		</a>
		{#if user}
			<span class="mr-auto <lg:hidden pl-6 pr-2 pl-3 pt-0.19rem">
				{#each nav1 as [title, href]}
					<a class="btn light-text border-0 pl-3" {href}>
						{title}
					</a>
				{/each}
			</span>
			<span class="float-right ml-auto items-center gap-4">
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
					class="flex items-center no-underline <sm:w-20"
					style="color: rgb(5, 150, 105) !important">
					<fa fa-gem class="pr-2" />
					{user.currency}
				</a>
				<div
					id="hover"
					class="dropdown dropdown-hover dropdown-end pl-2">
					<StudioUser
						{user}
						class="<sm:hidden"
						thin
						bg="background"
						size="2.4rem"
						full />
					<StudioUser
						{user}
						class="sm:hidden"
						thin
						bg="background"
						size="2.4rem" />
					<div id="dropdown" class="hidden dropdown-content pt-2">
						<ul class="bg-darker p-2 rounded-3">
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
			</span>
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
		class="bg-darker lg:hidden fixed bottom-0 w-full h-14 sm:h-16 z-11">
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
</style>
