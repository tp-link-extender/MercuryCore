<script lang="ts">
	import { enhance } from "$app/forms"
	import { goto } from "$app/navigation"
	import fade from "$lib/fade"

	let search = ""
	let searchCompleted = true
	let currentSearchFocus = -1

	$: if (search === "") {
		searchCompleted = true
		currentSearchFocus = -1
	}

	let searchInput: HTMLInputElement
	const searchResults: HTMLElement[] = []

	const searchCategories = [
		["Users", "users"],
		["Places", "places"],
		["Catalog", "assets"]
	]

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
</script>

<svelte:window
	on:keydown={e => {
		// the right way (actually works on different keyboard layouts)
		if (e.ctrlKey && e.key === "k") {
			e.preventDefault()
			searchInput.focus()
		}
	}} />

<form
	use:enhance
	method="POST"
	action="/search"
	role="search"
	class="mx-auto px-2 pb-1">
	<div
		class="input-group max-w-140 xl:(absolute left-1/2 top-2 -translate-x-1/2 w-35vw) lg:w-76 md:w-100 sm:w-52">
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
				if (search.trim()) goto(`/search?q=${search.trim()}&c=users`)
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

<style>
	#results a:hover {
		background: var(--accent);
	}
</style>
