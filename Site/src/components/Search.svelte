<script lang="ts">
	import { untrack } from "svelte"
	import { browser } from "$app/environment"
	import { goto } from "$app/navigation"

	const { pages }: { pages: string[] } = $props()

	let search = $state("")
	let searchFocus = $state(-1)
	$effect(() => {
		if (search === "") searchFocus = -1
	})

	let searchText = $state("Search")

	// only show after JS loads to allow for ctrl+k to be detected
	new Promise(r => r(0)).then(() => {
		if (browser) searchText += " (ctrl+k)"
	})

	let searchInput = $state<HTMLInputElement>()
	const searchResults: HTMLElement[] = $state([])

	let searchCategories: [string, string][] = $state([])
	$effect(() => {
		searchCategories = [
			["Games", "games"],
			["Users", "users"],
			["Places", "places"],
			["Catalog", "assets"]
		]
		untrack(() => {
			if (pages.includes("Groups"))
				searchCategories.push(["Groups", "groups"])
		})
	})

	function keydown(
		e: KeyboardEvent & {
			currentTarget: EventTarget & HTMLInputElement
		}
	) {
		switch (e.key) {
			case "Enter":
				e.preventDefault()
				searchResults[Math.max(0, searchFocus)].click() // better but not perfect

				searchFocus = -1
				break
			case "ArrowDown":
			case "ArrowUp": {
				e.preventDefault()

				// Focus first result
				searchResults[searchFocus]?.classList.remove("pseudofocus")

				searchFocus += e.key === "ArrowDown" ? 1 : -1
				if (searchFocus >= searchCategories.length) searchFocus = 0
				else if (searchFocus < 0)
					searchFocus = searchCategories.length - 1

				searchResults[searchFocus]?.classList.add("pseudofocus")
				break
			}
			case "Escape":
				search = ""
		}
	}
</script>

<svelte:window
	onkeydown={e => {
		// the right way (actually works on different keyboard layouts, lookin at you {insert several docs sites})
		if (!e.ctrlKey || e.key !== "k") return
		e.preventDefault()
		searchInput?.focus()
	}} />

<form action="/search" role="search" class="mx-auto px-2 pb-1">
	<div
		class="max-w-140 2xl:(absolute left-1/2 top-2 -translate-x-1/2 w-30vw) xl:w-130 lg:w-76 md:w-100 sm:w-52">
		<input
			bind:this={searchInput}
			bind:value={search}
			onkeydown={keydown}
			class="bg-background h-10 pl-4 w-full"
			name="q"
			type="search"
			placeholder={searchText}
			aria-label={searchText}
			autocomplete="off" />
		<div
			id="results"
			class="bg-darker absolute p-2 rounded-3 min-w-25vw max-w-full -translate-x-1/2 transition-all duration-300 ease-in-out z-10">
			{#each searchCategories as [name, value], num}
				<button
					bind:this={searchResults[num]}
					onclick={e => {
						e.preventDefault()
						goto(`/search?q=${search}&c=${value}`)
					}}
					class="btn light-text block w-full py-2 text-start"
					name="c"
					{value}
					title="Search {name}">
					Search <b class="break-all">{search}</b>
					in {name}
				</button>
			{/each}
		</div>
	</div>
</form>

<style>
	#results {
		top: 3.375rem;
		left: 50%;
		outline: transparent;
		filter: drop-shadow(0 20px 13px rgba(255, 255, 255, 0.02))
			drop-shadow(0 8px 5px rgba(255, 255, 255, 0.05));
		border: 1px solid var(--accent);
		opacity: 0;
		visibility: hidden;

		& button:hover {
			background: var(--accent);
		}
	}

	:global(.pseudofocus) {
		color: var(--grey-text) !important;
		background: var(--accent);
	}

	/* not empty and focussed  */
	input[type="search"]:not(:placeholder-shown):focus ~ #results {
		opacity: 1;
		visibility: visible;
	}
</style>
